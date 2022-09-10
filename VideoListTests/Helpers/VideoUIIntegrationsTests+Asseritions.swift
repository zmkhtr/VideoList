//
//  VideoUIIntegrationsTests+Asseritions.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import XCTest
import Video
import VideoUI

extension VideoUIIntegrationTests {
    func assertThat(_ sut: VideoViewController, isRendering video: [Video], file: StaticString = #filePath, line: UInt = #line) {
        
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedVideoView() == video.count else {
            return XCTFail("Expected \(video.count) videos, got \(sut.numberOfRenderedVideoView()) instead", file: file, line: line)
        }
        
        video.enumerated().forEach { index, video in
            assertThat(sut, hasViewConfiguredFor: video, at: index, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    private func executeRunLoopToCleanUpReferences() {
         RunLoop.current.run(until: Date())
     }
    
    func assertThat(_ sut: VideoViewController, hasViewConfiguredFor video: Video, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.video(at: index)
        
        guard let cell = view as? VideoCell else {
            return XCTFail("Expected \(VideoCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertTrue(cell.videoRetryButton.isHidden, "Expected `playerLayer` is not nil for video view at index (\(index))", file: file, line: line)
    }
}


extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
