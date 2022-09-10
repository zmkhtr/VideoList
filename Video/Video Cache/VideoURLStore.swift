//
//  VideoURLStore.swift
//  Video
//
//  Created by PT.Koanba on 09/09/22.
//

import Foundation

public protocol VideoURLStore {
    typealias RetrievalResult = Swift.Result<URL?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ localUrl: URL, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(videoPathForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}
