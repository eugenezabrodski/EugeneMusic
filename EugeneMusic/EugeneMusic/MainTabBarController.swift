//
//  MainTabBarController.swift
//  EugeneMusic
//
//  Created by Eugene on 08/02/2024.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: AnyObject {
    func minimazeTrackDetailController()
    func maximazeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    private var minimazeTopAnchor: NSLayoutConstraint!
    private var maximazeTopAnchor: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        setupTrackDetailView()
        searchVC.tabBarDelegate = self
        var library = Library()
        library.tabBarDelegate = self
        let hostingVC = UIHostingController(rootView: library)
        hostingVC.tabBarItem.image = UIImage(systemName: "music.note.house.fill")
        hostingVC.tabBarItem.title = "Library"
        viewControllers = [
            generateVC(rootViewController: searchVC, image: UIImage(systemName: "waveform.badge.magnifyingglass"), title: "Search"),
            hostingVC
        ]
    }
    
    //MARK: - Methods
    
    private func generateVC(rootViewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximazeTopAnchor = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximazeTopAnchor.isActive = true
        minimazeTopAnchor = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
//        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

//MARK: - MainTabBarController: MainTabBarControllerDelegate

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximazeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimazeTopAnchor.isActive = false
        maximazeTopAnchor.isActive = true
        maximazeTopAnchor.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximizedStackView.alpha = 1
        }
        
        guard let viewModel = viewModel else  { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    func minimazeTrackDetailController() {
        maximazeTopAnchor.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimazeTopAnchor.isActive = true
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximizedStackView.alpha = 0
        }
    }
    
    
}
