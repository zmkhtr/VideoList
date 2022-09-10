//
//  VideoCellController.swift
//  VideoUI
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import Video
import UIKit

public protocol VideoCellControllerDelegate {
    func didRequestVideo()
    func didCancelVideoRequest()
}

public final class VideoCellController: HLSVideoView {
    private let delegate: VideoCellControllerDelegate
    private var cell: VideoCell?
    private var row: Int?

    public init(delegate: VideoCellControllerDelegate) {
        self.delegate = delegate
    }

    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCell
        row = indexPath.row
        delegate.didRequestVideo()
        return cell!
    }

    func preload() {
        delegate.didRequestVideo()
    }

    func cancelLoad() {
        cell?.pauseVideo()
        releaseCellForReuse()
        delegate.didCancelVideoRequest()
    }
    
    func play() {
        cell?.playVideo()
    }
    
    public func display(_ model: HLSVideoViewModel) {
        if let item = model.playerItem {
            cell?.setVideo(with: item, autoplay: row == 0)
        }
        cell?.onRetry = delegate.didRequestVideo
        cell?.videoRetryButton.isHidden = !model.shouldRetry
        model.isLoading ? cell?.videoLoadingIndicator.startAnimating() : cell?.videoLoadingIndicator.stopAnimating()
    }

    private func releaseCellForReuse() {
        cell?.releasePlayerForReuse()
        cell = nil
    }
}
