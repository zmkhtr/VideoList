//
//  VideoViewController.swift
//  VideoUI
//
//  Created by PT.Koanba on 10/09/22.
//

import UIKit
import Video

public protocol VideoViewControllerDelegate {
    func didRequestVideoRefresh()
}

public final class VideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout, VideoLoadingView, VideoErrorView {
    @IBOutlet private(set) public var errorView: UILabel!
    @IBOutlet private(set) public var collectionView: UICollectionView!
    
    public lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        return refresh
    }()
    
    private var loadingControllers = [IndexPath: VideoCellController]()

    private var collectionModel = [VideoCellController]() {
        didSet { self.collectionView?.reloadData() }
    }

    public var delegate: VideoViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        refreshCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView?.refreshControl = refreshControl
        refreshControl.beginRefreshing()
    }

    @objc private func refreshCollectionView() {
        errorView?.isHidden = true
        stopPlayingVideo()
        delegate?.didRequestVideoRefresh()
    }
    
    private func stopPlayingVideo() {
        loadingControllers.forEach { key, cell in
            cell.cancelLoad()
        }
    }

    public func display(_ cellControllers: [VideoCellController]) {
        loadingControllers = [:]
        collectionModel = cellControllers
    }

    public func display(_ viewModel: VideoLoadingViewModel) {
        refreshControl.update(isRefreshing: viewModel.isLoading)
    }

    public func display(_ viewModel: VideoErrorViewModel) {
        errorView?.isHidden = false
        errorView?.text = viewModel.message
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellController(forRowAt: indexPath).view(in: collectionView, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)

    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> VideoCellController {
        let controller = collectionModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        getStopedScrollCellIndex(scrollView)
    }
    
    public func getStopedScrollCellIndex(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        let cell = cellController(forRowAt: indexPath)
        cell.play()
    }

}
