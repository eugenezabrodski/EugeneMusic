//
//  CMTime + Extension.swift
//  EugeneMusic
//
//  Created by Eugene on 13/02/2024.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString
    }
}
