//
//  MainTabBarController.swift
//  EugeneMusic
//
//  Created by Eugene on 08/02/2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        viewControllers = [
            generateVC(rootViewController: searchVC, image: UIImage(systemName: "waveform.badge.magnifyingglass"), title: "Search"),
            generateVC(rootViewController: ViewController(), image: UIImage(systemName: "music.note.list"), title: "Library")
        ]
    }
    
    private func generateVC(rootViewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
}
