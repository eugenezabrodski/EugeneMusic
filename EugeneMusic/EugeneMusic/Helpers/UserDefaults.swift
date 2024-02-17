//
//  UserDefaults.swift
//  EugeneMusic
//
//  Created by Eugene on 16/02/2024.
//

import Foundation


extension UserDefaults {
    
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func savedTrack() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTrack = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data,
              let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as? [SearchViewModel.Cell] else { return [] }
        return decodedTracks
    }
}
