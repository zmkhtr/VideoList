//
//  HLSVideoPresenterTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 10/09/22.
//

import XCTest
import Video
import AVFoundation

class HLSVideoPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingVideo_displaysLoadingVideo() {
        let (sut, view) = makeSUT()
        let video = uniqueVideo()
        
        sut.didStartLoadingVideo(for: video)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.playerItem)
    }
    
    func test_didFinishLoadingVideo_displaysVideoOnSuccessful() {
        let (sut, view) = makeSUT()
        let video = uniqueVideo()
        
        sut.didFinishLoadingPlayerItem(with: AVPlayerItem(url: anyURL()), for: video)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNotNil(message?.playerItem)
    }
    
    func test_didFinishLoadingVideoDataWithError_displaysRetry() {
        let (sut, view) = makeSUT()
        let video = uniqueVideo()
        
        sut.didFinishLoadingPlayerItem(with: anyNSError(), for: video)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.playerItem)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: HLSVideoPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = HLSVideoPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
        
    private class ViewSpy: HLSVideoView {
        private(set) var messages = [HLSVideoViewModel]()
        
        func display(_ model: HLSVideoViewModel) {
            messages.append(model)
        }
    }

}
