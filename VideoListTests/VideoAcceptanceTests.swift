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
    
    func test_onLaunch_displaysRemoteVideoWhenCustomerHasConnectivity() {
        let video = launch(httpClient: .online(response), store: .empty)
        video.loadViewIfNeeded()
        
//        XCTAssertEqual(video.numberOfRenderedVideoView(), 1)
//        XCTAssertEqual(video.playerItem(at: 0), makePlayerItem())
    }

    func test_onLaunch_displayEmptyVideoWhenCustomerHasNoConnectivity() {
        let video = launch(httpClient: .offline, store: .empty)
        video.loadViewIfNeeded()

        XCTAssertEqual(video.numberOfRenderedVideoView(), 0)
    }
    
    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryVideoStore = .empty
    ) -> VideoViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! VideoViewController
    }
    
    private func makePlayerLayer() -> AVPlayerLayer {
        return AVPlayerLayer()
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        default:
            return makeVideoData()
        }
    }
    
    private func makePlayerItem() -> AVPlayerItem {
        return AVPlayerItem(url: URL(string: "https://asset.anyurl.com/img/media/1645775133538.m3u8")!)
    }
    private func makeVideoData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "code": "1000",
            "message": "General Success",
            "data": [
                "content": [
                    "id": "2c948697825d276801825d73ad1a0217",
                    "typePost": "social",
                    "createdDate": nil,
                    "post": [
                        "type": "social",
                        "id": "2c948032821ab78501825c63b10621ec",
                        "medias": [
                            [
                                "id": UUID().uuidString,
                                "type": "video",
                                "url": "https://asset.anyurl.com/img/media/1645775133538.mp4",
                                "thumbnail": [
                                    "large": "https://asset.anyurl.com/img/media/1659407400010_288x512.jpg",
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
                                "hlsUrl": "https://asset.anyurl.com/img/media/1645775133538.m3u8"
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
                ],
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
        ])
    }
}
