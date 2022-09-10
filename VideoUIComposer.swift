//
//  VideoUIComposer.swift
//  VideoList
//
//  Created by PT.Koanba on 10/09/22.
//

import UIKit
import Video
import VideoUI

public final class VideoUIComposer {
    private init() {}
    
    public static func videoComposedWith(videoloader: VideoLoader, avVideoLoader: AVVideoLoader) -> VideoViewController {
        let presentationAdapter = VideoLoaderPresentationAdapter(videoLoader: MainQueueDispatchDecorator(decoratee: videoloader))
        
        let videoController = makeVideoViewController(delegate: presentationAdapter, title: VideoPresenter.title)

        presentationAdapter.presenter = VideoPresenter(
            videoView: VideoViewAdapter(
                controller: videoController,
                loader: MainQueueDispatchDecorator(decoratee: avVideoLoader)),
            loadingView: WeakRefVirtualProxy(videoController),
            errorView: WeakRefVirtualProxy(videoController))
        
        return videoController
    }
    
    static func makeVideoViewController(delegate: VideoViewControllerDelegate, title: String) -> VideoViewController {
        let bundle = Bundle(for: VideoViewController.self)
        let storyboard = UIStoryboard(name: "Video", bundle: bundle)
        let videoController = storyboard.instantiateInitialViewController() as! VideoViewController
        videoController.delegate = delegate
        videoController.title = VideoPresenter.title
        return videoController
    }
}


final class VideoLoaderPresentationAdapter: VideoViewControllerDelegate {
    private let videoLoader: VideoLoader
    var presenter: VideoPresenter?
    
    init(videoLoader: VideoLoader) {
        self.videoLoader = videoLoader
    }
    
    func didRequestVideoRefresh() {
        presenter?.didStartLoadingVideo()
        
        videoLoader.load { [weak self] result in
            switch result {
            case let .success(videos):
                self?.presenter?.didFinishLoadingVideo(with: videos)
            case let .failure(error):
                self?.presenter?.didFinishLoadingVideo(with: error)
            }
        }
    }
}


final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return  DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: VideoLoader where T == VideoLoader {
    func load(completion: @escaping (VideoLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: AVVideoLoader where T == AVVideoLoader {
    func loadAsset(for url: URL, completion: @escaping (AVVideoLoader.Result) -> Void) {
        return decoratee.loadAsset(for: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
    
    func cancel(for url: URL) {
        return decoratee.cancel(for: url)
    }
}


final class VideoViewAdapter: VideoView {
    private weak var controller: VideoViewController?
    private let loader: AVVideoLoader
    
    init(controller: VideoViewController, loader: AVVideoLoader) {
        self.controller = controller
        self.loader = loader
    }
    
    func display(_ viewModel: VideoViewModel) {
        controller?.display(viewModel.videos.map { video in
            let adapter = HLSVideoLoaderPresentationAdapter(model: video, loader: loader)
            let view = VideoCellController(delegate: adapter)
            
            adapter.presenter = HLSVideoPresenter(view: WeakRefVirtualProxy(view))
            
            return view
        })
    }
}


final class HLSVideoLoaderPresentationAdapter: VideoCellControllerDelegate {
    
    private let model: Video
    private let loader: AVVideoLoader
    
    var presenter: HLSVideoPresenter?
    
    init(model: Video, loader: AVVideoLoader) {
        self.model = model
        self.loader = loader
    }
    
    func didRequestVideo() {
        presenter?.didStartLoadingVideo(for: model)
        
        let model = self.model
        loader.loadAsset(for: model.hlsURL!) { [weak self ]result in
            switch result {
            case let .success(item):
                self?.presenter?.didFinishLoadingPlayerItem(with: item, for: model)
                
            case let.failure(error):
                self?.presenter?.didFinishLoadingPlayerItem(with: error, for: model)
            }
        }
    }
    
    
    func didCancelVideoRequest() {
        loader.cancel(for: model.hlsURL!)
    }
}


final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy : VideoLoadingView where T: VideoLoadingView {
    func display(_ viewModel: VideoLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy : VideoErrorView where T: VideoErrorView {
    func display(_ viewModel: VideoErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy : HLSVideoView where T: HLSVideoView {
    func display(_ model: HLSVideoViewModel) {
        object?.display(model)
    }
}

