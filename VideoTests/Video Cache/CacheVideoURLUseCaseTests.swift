//
//  CacheVideoURLUseCaseTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 09/09/22.
//

import XCTest
import Video

class CacheVideoURLUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    
    func test_saveLocalVideoPathForURL_requestsLocalVideoPathInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let localPath = anyLocalVideoPath()
        
        sut.save(localPath: localPath, for: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.insert(localPath, for: url)])
    }
    
    func test_saveLocalVideoPathFromURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveLocalVideoPathFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_saveLocalVideoPathFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = VideoURLStoreSpy()
        var sut: LocalVideoURLLoader? = LocalVideoURLLoader(store: store)
        
        var received = [LocalVideoURLLoader.SaveResult]()
        sut?.save(localPath: anyLocalVideoPath(), for: anyURL()) { received.append($0) }
        
        sut = nil
        store.completeInsertionSuccessfully()
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after instance gas been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalVideoURLLoader, store: VideoURLStoreSpy) {
        let store = VideoURLStoreSpy()
        let sut = LocalVideoURLLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> LocalVideoURLLoader.SaveResult {
        return .failure(LocalVideoURLLoader.SaveError.failed)
    }
    
    private func expect(_ sut: LocalVideoURLLoader, toCompleteWith expectedResult: LocalVideoURLLoader.SaveResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.save(localPath: anyLocalVideoPath(), for: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break
                
            case (.failure(let receivedError as LocalVideoURLLoader.SaveError), .failure(let expectedError as LocalVideoURLLoader.SaveError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
