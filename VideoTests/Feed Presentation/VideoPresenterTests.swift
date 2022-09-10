//
//  VideoPresenterTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 10/09/22.
//

import XCTest
import Video

class VideoPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(VideoPresenter.title, localized("VIDEO_VIEW_TITLE"))
    }
    
    func test_init_doesNotSendMessagesToView(){
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingVideo_displaysNoErrorMessageAndStartLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingVideo()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingVideo_displaysVideoAndStopLoading() {
        let (sut, view) = makeSUT()
        let video = [uniqueVideo(), uniqueVideo()]
        
        sut.didFinishLoadingVideo(with: video)
        
        XCTAssertEqual(view.messages, [
            .display(video: video),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingVideo_displayLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingVideo(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("VIDEO_VIEW_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: VideoPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = VideoPresenter(videoView: view, loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Video"
        let bundle = Bundle(for: VideoPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    private class ViewSpy: VideoView, VideoLoadingView, VideoErrorView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(video: [Video])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: VideoErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: VideoLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: VideoViewModel) {
            messages.insert(.display(video: viewModel.videos))
        }
    }
}
