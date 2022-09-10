//
//  LocalFeedImageDataLoader.swift
//  Video
//
//  Created by PT.Koanba on 09/09/22.
//

import Foundation

public final class LocalVideoURLLoader: VideoURLLoader {
    
    private let store: VideoURLStore
    
    public init(store: VideoURLStore) {
        self.store = store
    }
}

extension LocalVideoURLLoader: VideoURLCache {
    public typealias SaveResult = VideoURLCache.Result
    
    public enum SaveError: Error {
        case failed
    }
    
    public func save(localPath localUrl: URL, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(localUrl, for: url) { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed } )
        }
    }
}

extension LocalVideoURLLoader {
    public typealias LoadResult = VideoURLLoader.Result

    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    
    private final class Task: VideoURLLoaderTask {
        private var completion: ((LoadResult) -> Void)?
        
        init(_ completion: @escaping (LoadResult) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: LoadResult) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    
    public func loadVideoURL(from url: URL, completion: @escaping (LoadResult) -> Void) -> VideoURLLoaderTask  {
        let task = Task(completion)
        store.retrieve(videoPathForURL: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                            .mapError { _ in LoadError.failed}
                            .flatMap { data in
                data.map { .success($0) } ?? .failure(LoadError.notFound)
            })
        }
        return task
    }
}
