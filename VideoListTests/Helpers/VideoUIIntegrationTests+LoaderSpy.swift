//
//  VideoUIIntegrationTests+LoaderSpy.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import Video
import VideoUI
import AVFoundation

extension VideoUIIntegrationTests {
    
    class LoaderSpy : VideoLoader, AVVideoLoader {
        
        // MARK: - VideoLoader
        
        private var videoRequests = [(VideoLoader.Result) -> Void]()
        
        var loadVideoCallCount: Int {
            return videoRequests.count
        }
        
        func load(completion: @escaping (VideoLoader.Result) -> Void) {
            videoRequests.append(completion)
        }
        
        func completeVideoLoading(with videos: [Video] = [], at index: Int = 0) {
            videoRequests[index](.success(videos))
        }
        
        func completeVideoLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            videoRequests[index](.failure(error))
        }
        
        // MARK: - HLSVideoLoader
        
        private var hlsVideoRequests = [(url: URL, completion: (HLSVideoLoader.Result) -> Void)]()
        
        private(set) var cancelledHlsVideoURLs = [URL]()

        
        var loadedVideoURLs: [URL] {
            return hlsVideoRequests.map { $0.url }
        }
        
        func loadAsset(for url: URL, completion: @escaping (AVVideoLoader.Result) -> Void) {
            hlsVideoRequests.append((url, completion))
        }
        
        func cancel(for url: URL) {
            cancelledHlsVideoURLs.append(url)
        }
        
        func completeHLSVideoLoading(with item: AVPlayerItem = anyPlayerItem(), at index: Int = 0) {
            hlsVideoRequests[index].completion(.success(item))
        }
        
        func completeHLSVideoLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            hlsVideoRequests[index].completion(.failure(error))
        }
    }
}
