//
//  VideoErrorViewModel.swift
//  Video
//
//  Created by PT.Koanba on 10/09/22.
//

public struct VideoErrorViewModel {
    public let message: String?
    
    static var noError: VideoErrorViewModel {
        return VideoErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> VideoErrorViewModel {
        return VideoErrorViewModel(message: message)
    }
}
