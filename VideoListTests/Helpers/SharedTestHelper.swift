//
//  SharedTestHelper.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import AVFoundation
import XCTest
import Video

func anyPlayerItem() -> AVPlayerItem {
    AVPlayerItem(url: URL(string: "https://asset.anyurl.com/video/media/\(UUID().uuidString).m3u8")!)
}

func anyQueuePlayer() -> AVQueuePlayer {
    AVQueuePlayer(playerItem: anyPlayerItem())
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyHLSURL() -> URL {
    return URL(string: "http://any-url.com/\(UUID().uuidString).m3u8")!
}

func anyVideo() -> Video {
    return Video(id: UUID().uuidString, hlsURL: anyHLSURL(), thumbnailURL: anyURL())
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
