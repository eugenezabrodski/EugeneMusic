//
//  Library.swift
//  EugeneMusic
//
//  Created by Eugene on 16/02/2024.
//

import SwiftUI

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTrack()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximazeTrackDetailController(viewModel: self.track)
                        } label: {
                            Image(systemName: "play.fill")
                                .accentColor(.pink)
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                        }
                        Button {
                            self.tracks = UserDefaults.standard.savedTrack()
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .accentColor(.pink)
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                        }

                    }
                }
                .padding()
                .frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture()
                            .onEnded { _ in
                            let keyWindow = UIApplication.shared.connectedScenes
                                    .filter({ $0.activationState == .foregroundActive})
                                    .map({ $0 as? UIWindowScene})
                                    .compactMap({ $0 })
                                    .first?.windows
                                    .filter({ $0.isKeyWindow }).first
                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                            tabBarVC?.trackDetailView.delegate = self
                            self.track = track
                            self.showingAlert = true }
                            .simultaneously(with: TapGesture().onEnded{ _ in
                            self.track = track
                            self.tabBarDelegate?.maximazeTrackDetailController(viewModel: self.track)})
                        )
                    }.onDelete(perform: delete)
                }
            }
            .actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Delete?"), buttons: [.destructive(Text("Delete"), action: {
                        self.delete(track: self.track)}),
                    .cancel()])
            })
            .navigationTitle("Library")
        }
    }
    
    func delete(at offset: IndexSet) {
        tracks.remove(atOffsets: offset)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cell.iconUrlString ?? "person.fill")) { image in
                image.image?.resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

#Preview {
    Library()
}

extension Library: TrackMovingDelegate {
    func moveBack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForward() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    
}
