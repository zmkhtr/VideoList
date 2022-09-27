//
//  VideoCellController.swift
//  VideoUI
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import Video
import UIKit
import AVFoundation

public protocol VideoCellControllerDelegate {
    func didRequestVideo()
    func didCancelVideoRequest()
}

public final class VideoCellController: HLSVideoView {
    private let delegate: VideoCellControllerDelegate
    private var cell: VideoCell?
    private var row: Int?
    
    private(set) public var player: AVQueuePlayer?
    private(set) public var playerLooper: AVPlayerLooper?

    public init(delegate: VideoCellControllerDelegate) {
        self.delegate = delegate
    }

    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell
        row = indexPath.row
        
        if let player = player {
            cell?.setVideo(with: player)
        } else {
            delegate.didRequestVideo()
        }
        return cell!
    }
    
    func willDisplay(_ cell: UICollectionViewCell, in collectionView: UICollectionView, indexPath: IndexPath) {
        if let player = player {
            (cell as? VideoCell)?.setVideo(with: player)
        } else {
            delegate.didRequestVideo()
        }
    }

    func preload() {
        delegate.didRequestVideo()
    }

    func cancelLoad() {
        player?.pause()
        releaseCellForReuse()
        delegate.didCancelVideoRequest()
    }
    
    func play() {
        player?.play()
    }
    
    public func display(_ model: HLSVideoViewModel) {
        if let item = model.playerItem {
            let player = AVQueuePlayer(playerItem: item)
            playerLooper = AVPlayerLooper(player: player, templateItem: item)
            self.player = player
            
            if row == 0 {
                self.player?.play()
            }
            cell?.setVideo(with: player)
        }
        cell?.onRetry = delegate.didRequestVideo
        cell?.videoRetryButton.isHidden = !model.shouldRetry
        model.isLoading ? cell?.videoLoadingIndicator.startAnimating() : cell?.videoLoadingIndicator.stopAnimating()
    }

    private func releaseCellForReuse() {
        player?.pause()
        cell = nil
    }}
