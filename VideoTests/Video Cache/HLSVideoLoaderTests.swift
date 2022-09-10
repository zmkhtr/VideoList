//
//  HLSVideoLoaderTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 10/09/22.
//

import XCTest
import Video
/*
 This is the test
 */
class HLSVideoLoaderTests: XCTestCase {
    
//    func test_init_doesNotMessageStoreUponCreation() {
//        let (_, store) = makeSUT()
//
//        XCTAssertTrue(store.receivedMessages.isEmpty)
//    }
//
//    func test_loadLocalVideoPathFromURL_requestsStoredLocalVideoPathForURL() {
//        let (sut, store) = makeSUT()
//        let url = anyURL()
//
//        sut.loadAsset(for: url) { _ in }
//
//        XCTAssertEqual(store.receivedMessages, [.retrieve(localVideoPathFor: url)])
//    }
//
//    func test_loadLocalVideoPathFromURL_failsOnStoreError() {
//        let (sut, store) = makeSUT()
//
//        expect(sut, toCompleteWith: failed(), when: {
//            let retrievalError = anyNSError()
//            store.completeRetrieval(with: retrievalError)
//        })
//    }
//
//    func test_loadLocalVideoPathFromURL_deliversNotFoundErrorOnNotFound() {
//        let (sut, store) = makeSUT()
//
//        expect(sut, toCompleteWith: notFound(), when: {
//            store.completeRetrieval(with: .none)
//        })
//    }
//
//    func test_loadLocalVideoPathFromURL_deliversStoredLocalVideoPathOnFoundLocalVideoPath() {
//        let (sut, store) = makeSUT()
//        let foundLocalVideoPath = anyLocalVideoPath()
//
//        expect(sut, toCompleteWith: .success(foundLocalVideoPath), when: {
//            store.completeRetrieval(with: foundLocalVideoPath)
//        })
//    }
//
//    func test_loadVideoPathFromURL_doesNotDeliverResultAfterCancellingTask() {
//        let (sut, store) = makeSUT()
//        let foundData = anyURL()
//
//        var received = [VideoURLLoader.Result]()
//        let task = sut.loadVideoURL(from: anyURL()) { received.append($0) }
//        task.cancel()
//
//        store.completeRetrieval(with: foundData)
//        store.completeRetrieval(with: .none)
//        store.completeRetrieval(with: anyNSError())
//
//        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
//    }
//
//    func test_loadLocalVideoPathFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
//        let store = VideoURLStoreSpy()
//        var sut: LocalVideoURLLoader? = LocalVideoURLLoader(store: store)
//
//        var received = [VideoURLLoader.Result]()
//        _ = sut?.loadVideoURL(from: anyURL()) { received.append($0) }
//
//        sut = nil
//        store.completeRetrieval(with: anyLocalVideoPath())
//
//        XCTAssertTrue(received.isEmpty, "Expected no received results after instance has been deallocated")
//    }
    
    // MARK: - Helpers
    
//    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: HLSVideoLoader, store: VideoURLStoreSpy) {
//        let store = VideoURLStoreSpy()
//        let sut = HLSVideoLoader(identifier: "anyIdentifier", store: store)
//        trackForMemoryLeaks(store, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        return (sut, store)
//    }
    
//    private func failed() -> HLSVideoLoader.LoadResult {
//        return .failure(HLSVideoLoader.LoadError.failed)
//    }
//
//    private func notFound() -> LocalVideoURLLoader.LoadResult {
//        return .failure(LocalVideoURLLoader.LoadError.notFound)
//    }
//
//    private func never(file: StaticString = #file, line: UInt = #line) {
//        XCTFail("Expected no no invocations", file: file, line: line)
//    }
//    private func expect(_ sut: HLSVideoLoader, toCompleteWith expectedResult: AVVideoLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
//        let exp = expectation(description: "Wait for load completion")
//
//        sut.loadAsset(for: anyURL()) { receivedResult in
//            switch (receivedResult, expectedResult) {
//            case let (.success(receivedLocalVideoPath), .success(expectedLocalVideoPath)):
//                XCTAssertEqual(receivedLocalVideoPath, expectedLocalVideoPath, file: file, line: line)
//
//            case (.failure(let receivedError as HLSVideoLoader.LoadError), .failure(let expectedError as HLSVideoLoader.LoadError)):
//                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
//
//            default:
//                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
//            }
//        }
//        action()
//        wait(for: [exp], timeout: 1.0)
//    }
}
