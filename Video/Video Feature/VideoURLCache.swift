//
//  VideoURLCache.swift
//  Video
//
//  Created by PT.Koanba on 06/09/22.
//

import Foundation

public protocol VideoURLCache {
    typealias Result = Swift.Result<Void, Error>

    func save(localPath localUrl: URL, for url: URL, completion: @escaping (Result) -> Void)
}
