//
//  Video.swift
//  Video
//
//  Created by PT.Koanba on 05/09/22.
//

import Foundation

public struct Video: Hashable {
    public let id: String
    public let hlsURL: URL?
    
    public init(id: String, hlsURL: URL?) {
        self.id = id
        self.hlsURL = hlsURL
    }
}
