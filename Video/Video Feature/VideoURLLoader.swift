//
//  VideoURLLoader.swift
//  Video
//
//  Created by PT.Koanba on 06/09/22.
//

import Foundation
import AVFoundation

public protocol VideoURLLoaderTask {
    func cancel()
}

public protocol VideoURLLoader {
    typealias Result = Swift.Result<URL, Error>
    
    func loadVideoURL(from url: URL, completion: @escaping (Result) -> Void) -> VideoURLLoaderTask
}
