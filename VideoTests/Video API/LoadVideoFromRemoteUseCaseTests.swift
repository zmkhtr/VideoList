//
//  LoadVideoFromRemoteUseCaseTests.swift
//  VideoTests
//
//  Created by PT.Koanba on 05/09/22.
//

import XCTest
import Video

class LoadVideoFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load {_ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load {_ in }
        sut.load {_ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems(){
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID().uuidString,
            hlsURL: URL(string: "http://a-url.com/media/stream/1645775133538/1645775133538.m3u8")!,
            thumbnailURL: URL(string: "https://asset.anyurl.com/img/media/1645775133538_540x960.jpg")!)
        
        let item2 = makeItem(
            id: UUID().uuidString,
            hlsURL: nil,
            thumbnailURL: URL(string: "https://asset.anyurl.com/img/media/1645775133538_540x960.jpg")!)
    
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteVideoLoader? = RemoteVideoLoader(url: url, client: client)
        
        
        var capturedResults = [RemoteVideoLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteVideoLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteVideoLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteVideoLoader.Error) -> RemoteVideoLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: String, hlsURL: URL? = nil, thumbnailURL: URL) -> (model: Video, json: [String: Any]) {
        let item = Video(id: id, hlsURL: hlsURL, thumbnailURL: thumbnailURL)
        let json =  [
            "id": "2c948697825d276801825d73ad1a0217",
            "typePost": "social",
            "createdDate": nil,
            "post": [
                "type": "social",
                "id": "2c948032821ab78501825c63b10621ec",
                "medias": [
                    [
                        "id": id,
                        "type": "video",
                        "url": "https://asset.anyurl.com/img/media/1645775133538.mp4",
                        "thumbnail": [
                            "large": thumbnailURL.absoluteString,
                            "medium": "https://asset.anyurl.com/img/media/1659407400010_288x512.jpg",
                            "small": "https://asset.anyurl.com/img/media/1659407400010_144x256.jpg"
                        ],
                        "metadata": [
                            "width": "576",
                            "height": "1024",
                            "size": "20797",
                            "duration": 111.466667
                        ],
                        "isHlsReady": true,
                        "hlsUrl": hlsURL?.absoluteString as Any
                    ]
                ],
                "comments": nil,
                "description": "Kucing di ikat #trending",
                "channel": [
                    "id": "2c9481b674b001150174ba23c46b0387",
                    "name": "Cleeps 🇮🇩",
                    "code": "tiktok",
                    "description": "Make Your Day",
                    "photo": "https://asset.anyurl.com/img/media/1648712044473.png",
                    "isFollow": nil,
                    "createAt": 1600850740331
                ],
                "hashtags": [
                    [
                        "id": "2c948064744e2ea10174585604540674",
                        "value": "trending",
                        "total": 4700
                    ]
                ],
                "isScheduled": false,
                "scheduledTime": nil,
                "product": nil,
                "accountId": nil,
                "status": "APPROVED"
            ],
            "stories": [],
            "createAt": 1659425238298,
            "likes": 0,
            "comments": 0,
            "account": [
                "id": "2c948032821ab7850182393db80a4ad4",
                "username": "uutayang",
                "name": "uutayang",
                "bio": nil,
                "photo": "https://asset.anyurl.com/img/account/1662355509645.jpg",
                "birthDate": nil,
                "gender": nil,
                "isFollow": false,
                "isSeleb": true,
                "mobile": "433255656565",
                "email": "uut.ay@an.hg",
                "accountType": nil,
                "isVerified": false,
                "note": nil,
                "isDisabled": false,
                "isSeller": nil
            ],
            "isLike": false,
            "isFollow": false,
            "isReported": false,
            "totalView": nil,
            "origin": nil,
            "isAllImage": nil,
            "isAllHlsReady": nil
        ].compactMapValues { $0 }
        
        return (item, json as [String : Any])
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let json = [
            "code": "1000",
            "message": "General Success",
            "data": [
                "content": items,
                "pageable": [
                    "offsetPage": 0,
                    "sort": [
                        "sorted": true,
                        "unsorted": false,
                        "empty": false
                    ],
                    "startId": "",
                    "nocache": false,
                    "pageNumber": 0,
                    "pageSize": 1,
                    "offset": 0,
                    "paged": true,
                    "unpaged": false
                ],
                "totalElements": 1,
                "totalPages": 1,
                "last": true,
                "first": true,
                "sort": [
                    "sorted": true,
                    "unsorted": false,
                    "empty": false
                ],
                "numberOfElements": 1,
                "size": 1,
                "number": 0,
                "empty": false
            ]
        ] as [String : Any]
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
            
    private func expect(_ sut: RemoteVideoLoader, toCompleteWith expectedResult: RemoteVideoLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        
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
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}

