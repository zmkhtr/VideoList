//
//  SharedTestHelpers.swift
//  VideoTests
//
//  Created by PT.Koanba on 06/09/22.
//

import Foundation
import Video

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyLocalVideoPath() -> URL {
    let baseURL = URL(fileURLWithPath: NSHomeDirectory())
    return baseURL.appendingPathComponent("anyVideoPath")
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueVideo() -> Video {
    return Video(id: UUID().uuidString, hlsURL: anyURL())
}

