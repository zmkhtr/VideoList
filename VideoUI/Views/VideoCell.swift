//
//  VideoCell.swift
//  VideoUI
//
//  Created by PT.Koanba on 10/09/22.
//

import UIKit
import AVFoundation

public final class VideoCell: UICollectionViewCell {
    
    @IBOutlet private(set) public var videoContainer: UIView!
    
    private(set) public var player: AVQueuePlayer?
    private(set) public var playerLayer: AVPlayerLayer?
    private(set) public var playerLooper: AVPlayerLooper?
    @IBOutlet private(set) public var videoRetryButton: UIButton!
    @IBOutlet private(set) public var videoLoadingIndicator: UIActivityIndicatorView!
    
    var onRetry: (() -> Void)?
    

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoContainer.bounds
    }
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
    
    func setVideo(with item: AVPlayerItem, autoplay: Bool = false) {
        let player = AVQueuePlayer(playerItem: item)
        let playerLayer = AVPlayerLayer(player: player)
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        videoContainer.layer.addSublayer(playerLayer)
        
        self.player = player
        self.playerLayer = playerLayer
        
        if autoplay {
            self.player?.play()
        }
    }
    
    func releasePlayerForReuse() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player = nil
    }
    
    func playVideo() {
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
}
