//
//  InMemoryVideoStore.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import Video

class InMemoryVideoStore {
    private var hlsVideoCache: [URL: URL] = [:]
    
    private init() {
    }
}

extension InMemoryVideoStore: VideoURLStore {
    func insert(_ localUrl: URL, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        hlsVideoCache[url] = localUrl
        completion(.success(()))
    }
    
    func retrieve(videoPathForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        completion(.success(hlsVideoCache[url]))
    }
}

extension InMemoryVideoStore {
    static var empty: InMemoryVideoStore {
        InMemoryVideoStore()
    }
}
