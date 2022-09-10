//
//  VideoPresenter.swift
//  Video
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation

public protocol VideoView {
    func display(_ viewModel: VideoViewModel)
}

public protocol VideoLoadingView {
    func display(_ viewModel: VideoLoadingViewModel)
}

public protocol VideoErrorView {
    func display(_ viewModel: VideoErrorViewModel)
}

public final class VideoPresenter {
    private let videoView: VideoView
    private let errorView: VideoErrorView
    private let loadingView: VideoLoadingView

    private var videoLoadError: String {
        return NSLocalizedString("VIDEO_VIEW_CONNECTION_ERROR",
             tableName: "Video",
             bundle: Bundle(for: VideoPresenter.self),
             comment: "Error message displayed when we can't load the Videos from the server")
    }
    
    public init(videoView: VideoView, loadingView: VideoLoadingView, errorView: VideoErrorView) {
        self.videoView = videoView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        return NSLocalizedString("VIDEO_VIEW_TITLE",
                                 tableName: "Video",
                                 bundle: Bundle(for: VideoPresenter.self),
                                 comment: "Title for the Video view")
    }
    
    public func didStartLoadingVideo() {
        errorView.display(.noError)
        loadingView.display(VideoLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingVideo(with videos: [Video]) {
        videoView.display(VideoViewModel(videos: videos))
        loadingView.display(VideoLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingVideo(with error: Error) {
        errorView.display(.error(message: videoLoadError))
        loadingView.display(VideoLoadingViewModel(isLoading: false))
    }
}

