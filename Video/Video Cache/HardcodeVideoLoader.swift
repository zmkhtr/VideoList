//
//  HardcodeVideoLoader.swift
//  Video
//
//  Created by PT.Koanba on 13/09/22.
//

import Foundation

public final class HardcodeVideoLoader: VideoLoader {
    
    public typealias Result = VideoLoader.Result

    private let videos: [Video]
    
    public init(videos: [Video]) {
        self.videos = videos
    }
    
    public func load(completion: @escaping (VideoLoader.Result) -> Void) {
        completion(.success(videos))
    }
}
