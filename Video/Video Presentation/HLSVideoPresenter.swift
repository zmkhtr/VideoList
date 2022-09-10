//
//  HLSVideoPresenter.swift
//  Video
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import AVFoundation

public protocol HLSVideoView {
    func display(_ model: HLSVideoViewModel)
}

public final class HLSVideoPresenter {
    private let view: HLSVideoView

    public init(view: HLSVideoView) {
        self.view = view
    }
    
    public func didStartLoadingVideo(for model: Video) {
        view.display(HLSVideoViewModel(
            playerItem: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    public func didFinishLoadingPlayerItem(with playerItem: AVPlayerItem, for model: Video) {
        view.display(HLSVideoViewModel(
            playerItem: playerItem,
            isLoading: false,
            shouldRetry: false))
    }
    
    public func didFinishLoadingPlayerItem(with error: Error, for model: Video) {
        view.display(HLSVideoViewModel(
            playerItem: nil,
            isLoading: false,
            shouldRetry: true))
    }
}
