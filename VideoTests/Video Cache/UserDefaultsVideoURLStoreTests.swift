//
//  UserDefaultsVideoURLStoreTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 09/09/22.
//

import XCTest
import Video

class UserDefaultsVideoURLStoreTests: XCTestCase {
    
    func test_retrieveLocalVideoPath_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveLocalVideoPath_deliversNotFoundWhenStoredLocalVideoPathURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyLocalVideoPath(), for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveLocalVideoPath_deliversFoundLocalVideoPathWhenThereIsAStoredLocalVideoPathMatchingURL() {
        let sut = makeSUT()
        let storedLocalVideoPath = anyLocalVideoPath()
        let matchingURL = URL(string: "http://a-url.com")!
        
        insert(storedLocalVideoPath, for: matchingURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedLocalVideoPath), for: matchingURL)
    }
    
    func test_retrieveLocalVideoPath_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredLocalVideoPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("anyVideoPathFirst")
        let lastStoredLocalVideoPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("anyVideoPathLast")
        let url = URL(string: "http://a-url.com")!
        
        insert(firstStoredLocalVideoPath, for: url, into: sut)
        insert(lastStoredLocalVideoPath, for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoredLocalVideoPath), for: url)
    }
    
    func test_sideEffects_runSerially() {
        let sut = makeSUT()
        let url = anyURL()
        let storedLocalVideoPath = anyLocalVideoPath()

        let op1 = expectation(description: "Operation 1")
        sut.insert(storedLocalVideoPath, for: url) { _ in
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.insert(storedLocalVideoPath, for: url) { _ in op2.fulfill() }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(storedLocalVideoPath, for: url) { _ in op3.fulfill() }

        wait(for: [op1, op2, op3], timeout: 5.0, enforceOrder: true)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> UserDefaultsVideoURLStore {
        let userDefaults = UserDefaults(suiteName: #file)
        userDefaults?.removePersistentDomain(forName: #file)
        let sut = try! UserDefaultsVideoURLStore(userDefaults: userDefaults)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> VideoURLStore.RetrievalResult {
        return .success(.none)
    }
    
    private func found(_ localURL: URL) -> VideoURLStore.RetrievalResult {
        return .success(localURL)
    }
    
    private func expect(_ sut: UserDefaultsVideoURLStore, toCompleteRetrievalWith expectedResult: VideoURLStore.RetrievalResult, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.retrieve(videoPathForURL: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedLocalVideoPath), .success(expectedLocalVideoPath)):
                XCTAssertEqual(receivedLocalVideoPath, expectedLocalVideoPath, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func insert(_ localPath: URL, for url: URL, into sut: UserDefaultsVideoURLStore, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(localPath, for: url) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed to save \(localPath) with error \(error)", file: file, line: line)
                exp.fulfill()
                
            case .success:
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
}
