//
//  VideoViewController+TestsHelpers.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import VideoUI
import UIKit
import AVFoundation

extension VideoViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateVideoViewVisible(at index: Int) -> VideoCell? {
        return video(at: index) as? VideoCell
    }
    
    @discardableResult
    func simulateVideoViewNotVisible(at row: Int) -> VideoCell? {
        let view = simulateVideoViewVisible(at: row)
        
        let delegate = collectionView.delegate
        let index = IndexPath(row: row, section: videoSection)
        delegate?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: index)
        return view
    }
    
    func simulateVideoViewNearVisible(at row: Int) {
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(row: row, section: videoSection)
        ds?.collectionView(collectionView, prefetchItemsAt: [index])
    }
    
    func simulateVideoViewNotNearVisible(at row: Int) {
        simulateVideoViewNearVisible(at: row)
        
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(row: row, section: videoSection)
        ds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [index])
    }
    
    func simulateStopScrolling(at row: Int) {
        let ds = collectionView.delegate
        collectionView.scrollToItem(at: IndexPath(row: row, section: videoSection), at: .centeredVertically, animated: false)
        ds?.scrollViewDidEndDecelerating?(collectionView)
        getStopedScrollCellIndex(collectionView)
    }
    
    func renderedVideoLayer(at index: Int) -> AVPlayerLayer? {
        return simulateVideoViewVisible(at: index)?.renderedVideo
    }
    
    func playerItem(at index: Int) -> AVPlayerItem? {
        return simulateVideoViewVisible(at: index)?.player?.currentItem
    }
    
    func playerItemURL(at index: Int) -> URL? {
        let asset = self.playerItem(at: index)?.asset
         if asset == nil {
             return nil
         }
         if let urlAsset = asset as? AVURLAsset {
             return urlAsset.url
         }
         return nil
    }
    
    var errorMessage: String? {
        return errorView?.text
    }
    
    var isShowingLoadingIndicator : Bool {
        return refreshControl.isRefreshing ==  true
    }
    
    func numberOfRenderedVideoView() -> Int {
        return collectionView.numberOfItems(inSection: videoSection)
    }
    
    func video(at row: Int) -> UICollectionViewCell? {
        guard numberOfRenderedVideoView() > row else {
            return nil
        }
        let ds = collectionView.dataSource
        let index = IndexPath(row: row, section: videoSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
    
    private var videoSection : Int {
        return 0
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
