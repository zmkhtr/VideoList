//
//  VideoListTests.swift
//  VideoListTests
//
//  Created by PT.Koanba on 04/09/22.
//

import XCTest
import Video
import VideoUI
@testable import VideoList
import AVFoundation

class VideoAcceptanceTests: XCTestCase {
    
    /*
     Still cannot pass this test don't know why(?).
     */
    func test_onLaunch_displaysVideo() {
        let videos = [anyVideo()]
        let video = launch(videos: videos, store: .empty)
        video.loadViewIfNeeded()
        
        XCTAssertEqual(video.numberOfRenderedVideoView(), 1)
        XCTAssertEqual(video.playerItemURL(at: 0), try XCTUnwrap(videos.first?.hlsURL!))
    }
    
    // MARK: - Helpers
    
    private func launch(
        videos: [Video] = [],
        store: InMemoryVideoStore = .empty
    ) -> VideoViewController {
        let sut = SceneDelegate(videos: videos, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! VideoViewController
    }
}
