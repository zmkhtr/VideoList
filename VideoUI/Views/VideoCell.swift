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
    
    private(set) public lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(layer)
        return layer
    }()
    
    @IBOutlet private(set) public var videoRetryButton: UIButton!
    @IBOutlet private(set) public var videoLoadingIndicator: UIActivityIndicatorView!
    
    var onRetry: (() -> Void)?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.playerLayer.player = nil
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = videoContainer.bounds
    }
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
    
    func setVideo(with player: AVPlayer) {
        self.playerLayer.player = player
    }
}
