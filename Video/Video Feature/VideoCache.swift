//
//  VideoCache.swift
//  Video
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import AVFoundation

public protocol AVVideoLoader {
    typealias Result = Swift.Result<AVPlayerItem, Error>

    func loadAsset(for url: URL, completion: @escaping (AVVideoLoader.Result) -> Void)
    func cancel(for url: URL)
}
