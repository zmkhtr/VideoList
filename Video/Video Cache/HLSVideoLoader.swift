//
//  HLSVideoLoader.swift
//  Video
//
//  Created by PT.Koanba on 09/09/22.
//

import AVFoundation
/*
 This is some of the class, i want to ask how to test drive it properly?.
 This is the documentation i follow:
 https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/MediaPlaybackGuide/Contents/Resources/en.lproj/HTTPLiveStreaming/HTTPLiveStreaming.html
 */
public final class HLSVideoLoader: NSObject, AVAssetDownloadDelegate {
    
    private let configuration: URLSessionConfiguration
    private var downloadSession: AVAssetDownloadURLSession?
    private var delegate: AVAssetDownloadDelegate?
    private let store: VideoURLStore!
    private var task = [URL:AVAssetDownloadTask]()
    
    public init(identifier: String, store: VideoURLStore) {
        self.configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        self.store = store
        super.init()
        self.delegate = self
        self.downloadSession = AVAssetDownloadURLSession(
            configuration: configuration,
            assetDownloadDelegate: delegate,
            delegateQueue: OperationQueue.main)
    }
}

extension HLSVideoLoader: AVVideoLoader {
    public typealias LoadResult = AVVideoLoader.Result
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    public func loadAsset(for url: URL, completion: @escaping (LoadResult) -> Void) {
        store.retrieve(videoPathForURL: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(localPath):
                let baseURL = URL(fileURLWithPath: NSHomeDirectory())
                if let localPath = localPath {
                    let assetURL = baseURL.appendingPathComponent(localPath)
                    let asset = AVURLAsset(url: assetURL)
                    if let cache = asset.assetCache, cache.isPlayableOffline {
                        completion(.success(AVPlayerItem(asset: asset)))
                    } else {
                        self.downloadAndPlayAsset(for: url, completion: completion)
                    }
                } else {
                    self.downloadAndPlayAsset(for: url, completion: completion)
                }
            case .failure:
                completion(.failure(LoadError.failed))
            }
        }
    }
    
    private func downloadAndPlayAsset(for url: URL, completion: @escaping (LoadResult) -> Void) {
        let asset = AVURLAsset(url: url)
        let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
                                                                 assetTitle: url.absoluteString,
                                                                 assetArtworkData: nil,
                                                                 options: nil)
                                
        downloadTask?.resume()
        
        if let downloadTask = downloadTask {
            task[url] = downloadTask
            completion(.success(AVPlayerItem(asset: downloadTask.urlAsset)))
        } else {
            completion(.failure(LoadError.failed))
        }
    }
    
    public func cancel(for url: URL) {
        task[url]?.cancel()
        task[url] = nil
    }
}

extension HLSVideoLoader {
    public func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        saveIgnoringResult(assetDownloadTask, location.relativePath)
    }
}

private extension HLSVideoLoader {
    func saveIgnoringResult(_ assetDownloadTask: AVAssetDownloadTask, _ location: String) {
        if let url = task.first(where: { $0.value == assetDownloadTask })?.key {
            store.insert(location, for: url) { _ in }
        }
    }
}

