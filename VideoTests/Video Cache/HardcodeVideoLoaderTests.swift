//
//  HardcodeVideoLoaderTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 13/09/22.
//

import XCTest
import Video

class LoadVideoFromHardcodeUseCaseTests: XCTestCase {
    
    func test_init_withEmptyDataRequestEmptyData() {
        let sut = makeSUT(videos: [])
        
        expect(sut, toCompleteWith: .success([]))
    }
    
    func test_init_withDataNonEmptyDataRequestNonEmptyData() {
        let videos = [uniqueVideo(), uniqueVideo(), uniqueVideo()]
        let sut = makeSUT(videos: videos)
        
        expect(sut, toCompleteWith: .success(videos))
    }
    
    // MARK: - Helpers
    private func makeSUT(videos: [Video] = [], file: StaticString = #filePath, line: UInt = #line) -> HardcodeVideoLoader {
        let sut = HardcodeVideoLoader(videos: videos)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: HardcodeVideoLoader, toCompleteWith expectedResult: HardcodeVideoLoader.Result, file: StaticString = #filePath, line: UInt = #line){
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteVideoLoader.Error), .failure(expectedError as RemoteVideoLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

