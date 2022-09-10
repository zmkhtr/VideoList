//
//  VideoCell+TestHelpers.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import VideoUI
import UIKit
import AVFoundation

extension VideoCell {
    
    func simulateRetryAction() {
        videoRetryButton.simulateTap()
    }
    
    var isShowingRetryAction: Bool {
        return !videoRetryButton.isHidden
    }
    
    var renderedVideo: AVPlayerLayer? {
        return playerLayer
    }
    
    var currentRenderedVideoItem: AVPlayerItem? {
        return renderedVideo?.player?.currentItem
    }
    
    var isShowingVideoLoadingIndicator: Bool {
        return videoLoadingIndicator.isAnimating
    }
    
    var isVideoPlaying: Bool {
        return player?.rate != 0.0 && player?.error == nil
    }
    
    var isVideoPaused: Bool {
        return player?.rate == 0.0 && player?.error == nil
    }
}


extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
