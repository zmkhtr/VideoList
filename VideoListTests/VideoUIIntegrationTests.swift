//
//  VideoUIIntegrationTests.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import XCTest
import UIKit
import Video
import VideoUI
import VideoList
import AVFoundation

final class VideoUIIntegrationTests: XCTestCase {
    
    func test_videoView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, localized("VIDEO_VIEW_TITLE"))
    }

    func test_loadVideoActions_requestVideoFromLoader() {
        let (sut, loader) = makeSUT()

        XCTAssertEqual(loader.loadVideoCallCount, 0, "Expected no loading request before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadVideoCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadVideoCallCount, 2, "Expected another loading request once user initiates a load")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadVideoCallCount, 3, "Expected a third loading request once user initiates another load")
    }

    func test_loadingVideoIndicator_isVisibleWhileLoadingVideo() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeVideoLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user is initiates a reload")

        loader.completeVideoLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user is initiated loading completes with error")
    }

    func test_loadVideoCompletion_rendersSuccessfullyLoadedVideo() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let video2 = makeVideo(hlsURL: anyHLSURL())
        let video3 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeVideoLoading(with: [video0], at: 0)
        assertThat(sut, isRendering: [video0])

        sut.simulateUserInitiatedFeedReload()
        loader.completeVideoLoading(with: [video0, video1, video2, video3], at: 1)
        assertThat(sut, isRendering: [video0, video1, video2, video3])
    }

    func test_loadVideoCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0], at: 0)
        assertThat(sut, isRendering: [video0])

        sut.simulateUserInitiatedFeedReload()
        loader.completeVideoLoadingWithError(at: 1)
        assertThat(sut, isRendering: [video0])
    }

    func test_loadVideoCompletion_rendersSuccessfullyLoadedEmptyVideoAfterNonEmptyVideo() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0, video1], at: 0)
        assertThat(sut, isRendering: [video0, video1])

        sut.simulateUserInitiatedFeedReload()
        loader.completeVideoLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }

    func test_loadVideoCompletion_rendersErrorMessageOnError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeVideoLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, localized("VIDEO_VIEW_CONNECTION_ERROR"))

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_videoView_loadsVideoURLWhenVisible() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0, video1])

        XCTAssertEqual(loader.loadedVideoURLs, [], "Expected no video URL requests until views become visible")

        sut.simulateVideoViewVisible(at: 0)
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL], "Expected first video URL request once first view becomes visible")

        sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL, video1.hlsURL], "Expected second video URL request once first view also becomes visible")
    }

    func test_hlsVideoView_cancelsVideoLoadingLWhenNotVisibleAnymore() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0, video1])
        XCTAssertEqual(loader.cancelledHlsVideoURLs, [], "Expected no video URL requests until video is not visible")

        sut.simulateVideoViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledHlsVideoURLs, [video0.hlsURL], "Expected one cancelled video URL request once first video is not visible anymore")

        sut.simulateVideoViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledHlsVideoURLs, [video0.hlsURL, video1.hlsURL], "Expected two cancelled video URL requests once second video is also not visible anymore")
    }

    func test_hlsVideoViewLoadingIndicator_isVisibleWhileLoadingVideo() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo(), makeVideo()])

        let view0 = sut.simulateVideoViewVisible(at: 0)
        let view1 = sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingVideoLoadingIndicator, true, "Expected loading indicator for first view while loading first video")
        XCTAssertEqual(view1?.isShowingVideoLoadingIndicator, true, "Expected loading indicator for second view while loading first video")

        loader.completeHLSVideoLoading(at: 0)
        XCTAssertEqual(view0?.isShowingVideoLoadingIndicator, false, "Expected no loading indicator for first view once first video loading completes successfully")
        XCTAssertEqual(view1?.isShowingVideoLoadingIndicator, true, "Expected no loading indicator state change for second view once first video loading completes successfully")

        loader.completeHLSVideoLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingVideoLoadingIndicator, false, "Expected no loading indicator state change for first view once second video loading completes with error")
        XCTAssertEqual(view1?.isShowingVideoLoadingIndicator, false, "Expected no loading for second view once second video loading completes with error")
    }

    func test_hlsVideoView_rendersVideoLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo(), makeVideo()])

        let view0 = sut.simulateVideoViewVisible(at: 0)
        let view1 = sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(view0?.currentRenderedVideoItem, .none, "Expected no video for first view while loading first video")
        XCTAssertEqual(view1?.currentRenderedVideoItem, .none, "Expected no video for second view while loading second video")

        let playerItem0 = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem0, at: 0)
        XCTAssertEqual(view0?.currentRenderedVideoItem, playerItem0, "Expected video for first view once first video loading completes successfully")
        XCTAssertEqual(view1?.currentRenderedVideoItem, .none, "Expected no video state change for second view once video loading completes successfully")

        let playerItem1 = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem1, at: 1)
        XCTAssertEqual(view0?.currentRenderedVideoItem, playerItem0, "Expected no video state chage for first view once second video loading completes successfully")
        XCTAssertEqual(view1?.currentRenderedVideoItem, playerItem1, "Expected video for second view once second video loading completes successfully")
    }

    func test_hlsVideoViewRetryButton_isVisibleOnVideoURLLoadError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo(), makeVideo()])

        let view0 = sut.simulateVideoViewVisible(at: 0)
        let view1 = sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first video")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second video")

        let playerItem = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first video loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once video loading completes successfully")

        loader.completeHLSVideoLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state chage for first view once second video loading completes error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second video loading completes successfully")
    }

    func test_hlsVideoViewRetryAction_retriesVideoLoad() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0, video1])

        let view0 = sut.simulateVideoViewVisible(at: 0)
        let view1 = sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL, video1.hlsURL], "Expected two video URL request for the two visible views")

        loader.completeHLSVideoLoadingWithError(at: 0)
        loader.completeHLSVideoLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL, video1.hlsURL], "Expected only two video URL requests before retry action")

        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL, video1.hlsURL, video0.hlsURL], "Expected third video URL requests after first view retry action")

        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedVideoURLs,  [video0.hlsURL, video1.hlsURL, video0.hlsURL, video1.hlsURL], "Expected fourth videoURL request after second view retry action")
    }

    func test_hlsVideoView_preloadsVideoURLWhenNearVisible() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0, video1])
        XCTAssertEqual(loader.loadedVideoURLs, [], "Expected no video URL request until video is near visible")

        sut.simulateVideoViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL], "Expected first video URL request once first video is near visible")

        sut.simulateVideoViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedVideoURLs, [video0.hlsURL, video1.hlsURL], "Expected second video URL request once second video is near visible")
    }

    func test_hlsVideoView_cancelsVideoURLPreloadingWhenNotNearVisibleAnymore() {
        let video0 = makeVideo(hlsURL: anyHLSURL())
        let video1 = makeVideo(hlsURL: anyHLSURL())
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [video0, video1])
        XCTAssertEqual(loader.cancelledHlsVideoURLs, [], "Expected no cancelled video URL request until video is not near visible")

        sut.simulateVideoViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledHlsVideoURLs, [video0.hlsURL], "Expected first cancelled video URL request once first video is not near visible")

        sut.simulateVideoViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledHlsVideoURLs, [video0.hlsURL, video1.hlsURL], "Expected second cancelled video URL request once second video is not near visible")
    }

    func test_hlsVideoView_doesNotRenderLoadedVideoWhenNotVisibleAnymore(){
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo()])

        let view = sut.simulateVideoViewNotVisible(at: 0)
        loader.completeVideoLoading(with: [anyVideo()])

        XCTAssertNil(view?.renderedVideo, "Expected no rendered video when an video load finishes after the view is not visible anymore")
    }

    func test_LoadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeVideoLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_loadVideoDataCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo()])
        _ = sut.simulateVideoViewVisible(at: 0)

        let exp = expectation(description: "Wait for background queue work")
        DispatchQueue.global().async {
            loader.completeVideoLoading(with: [anyVideo()], at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_autoPlayVideo_afterFinishLoadingInFirstIndex() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo(), makeVideo()])

        let view0 = sut.simulateVideoViewVisible(at: 0)
        let view1 = sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(view0?.currentRenderedVideoItem, .none, "Expected no video for first view while loading first video")
        XCTAssertEqual(view1?.currentRenderedVideoItem, .none, "Expected no video for second view while loading second video")

        let playerItem0 = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem0, at: 0)
        XCTAssertEqual(view0?.currentRenderedVideoItem, playerItem0, "Expected video for first view once first video loading completes successfully")
        XCTAssertEqual(view1?.currentRenderedVideoItem, .none, "Expected no video state change for second view once video loading completes successfully")

        let playerItem1 = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem1, at: 1)
        XCTAssertEqual(view0?.currentRenderedVideoItem, playerItem0, "Expected no video state chage for first view once second video loading completes successfully")
        XCTAssertEqual(view1?.currentRenderedVideoItem, playerItem1, "Expected video for second view once second video loading completes successfully")
        
        XCTAssertTrue(try XCTUnwrap(view0?.isVideoPlaying), "Expected video autoplay on First Index")
        XCTAssertFalse(try XCTUnwrap(view1?.isVideoPlaying), "Expected video not autoplay on second Index")
    }
    
    func test_autoPlayVideo_afterFinishLoadingOnStoppedIndex() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeVideoLoading(with: [makeVideo(), makeVideo()])

        var view0 = sut.simulateVideoViewVisible(at: 0)
        var view1 = sut.simulateVideoViewVisible(at: 1)
        XCTAssertEqual(view0?.currentRenderedVideoItem, .none, "Expected no video for first view while loading first video")
        XCTAssertEqual(view1?.currentRenderedVideoItem, .none, "Expected no video for second view while loading second video")

        let playerItem0 = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem0, at: 0)
        XCTAssertEqual(view0?.currentRenderedVideoItem, playerItem0, "Expected video for first view once first video loading completes successfully")
        XCTAssertEqual(view1?.currentRenderedVideoItem, .none, "Expected no video state change for second view once video loading completes successfully")

        let playerItem1 = anyPlayerItem()
        loader.completeHLSVideoLoading(with: playerItem1, at: 1)
        XCTAssertEqual(view0?.currentRenderedVideoItem, playerItem0, "Expected no video state chage for first view once second video loading completes successfully")
        XCTAssertEqual(view1?.currentRenderedVideoItem, playerItem1, "Expected video for second view once second video loading completes successfully")
        
        XCTAssertTrue(try XCTUnwrap(view0?.isVideoPlaying), "Expected video autoplay on First Index")
        
        view0 = sut.simulateVideoViewNotVisible(at: 0)
        XCTAssertNil(view0?.player, "Expected video not visible deallocated")
        
        sut.simulateStopScrolling(at: 1)
        XCTAssertTrue(try XCTUnwrap(view1?.isVideoPlaying), "Expected video autoplay on stopped index")
        
        sut.simulateStopScrolling(at: 0)
        XCTAssertTrue(try XCTUnwrap(view0?.isVideoPlaying), "Expected video autoplay on First Index")
        
        view1 = sut.simulateVideoViewNotVisible(at: 1)
        XCTAssertNil(view1?.player, "Expected video not visible deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: VideoViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = VideoUIComposer.videoComposedWith(videoloader: loader, avVideoLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    
    private func makeVideo(hlsURL: URL = anyHLSURL()) -> Video {
        return Video(id: UUID().uuidString, hlsURL: hlsURL)
    }
    
    private func makePlayerLayer() -> AVPlayerLayer {
        return AVPlayerLayer()
    }
}
