//
//  RemoteVideo.swift
//  Video
//
//  Created by PT.Koanba on 05/09/22.
//

import Foundation

struct RemoteFeedItem: Codable {
    let content: [RemoteFeed]
    let pageable: RemotePageable?
    let totalPages, totalElements: Int?
    let last: Bool?
    let sort: RemoteSort?
    let numberOfElements: Int?
    let first: Bool?
    let size, number: Int?
    let empty: Bool?
}

struct RemoteFeed: Codable {
    
    let id: String?
    let typePost: String?
    let post: RemotePost
    let createAt: Int?
    let likes, comments: Int?
    let account: RemoteProfile?
    let isRecomm, isReported, isLike, isFollow, isProductActiveExist: Bool?
    let stories: [RemoteStories]?
    let valueBased: String?
    let typeBased: String?
    let similarBy: String?
    let mediaCategory: String?
}

struct RemotePost: Codable {
    let type: String?
    let product: RemoteProduct?
    let price: Int?
    let channel: RemoteChannel?
    let id, name, description: String?
    let medias: [RemoteMedias]
    let hashtags: [RemoteHashtag]?
}

struct RemoteHashtag: Codable {
    let value: String?
    let total: Int?
}

struct RemoteMedias: Codable {
    let id: String
    let type: String?
    let url: URL
    let isHlsReady: Bool?
    let hlsUrl: URL?
    let thumbnail: RemoteThumbnail
    let metadata: RemoteMetadata?
}

struct RemoteMetadata: Codable {
    let width, height, size: String?
    let duration: Double?
}

struct RemoteThumbnail: Codable {
    let large, medium, small: URL
}

struct RemotePageable: Codable {
    let sort: RemoteSort?
    let pageNumber, pageSize, offset: Int?
    let paged, unpaged: Bool?
}

struct RemoteSort: Codable {
    let sorted, unsorted, empty: Bool?
}

struct RemoteProfile : Codable {
    let accountType : String?
    let bio : String?
    let email : String?
    let id : String?
    let isFollow : Bool?
    let birthDate: String?
    let note: String?
    let isDisabled: Bool?
    let isSeleb: Bool?
    let isVerified : Bool?
    let mobile : String?
    let name : String?
    let photo : String?
    let username : String?
    let isSeller: Bool?
    let socialMedias: [RemoteSocialMedia]?
}
struct RemoteSocialMedia : Codable {
    let socialMediaType : String?
    let urlSocialMedia : String?
}

struct RemoteStories: Codable {
    let id: String?
    let medias: [RemoteMedias]?
    let products: [RemoteProduct]?
    let createAt: Int?
}

struct RemoteMeasurement: Codable {
    let weight, length, height, width: Double?
}

struct RemoteProduct: Codable {
    let accountId : String?
    let description : String?
    let generalStatus : String?
    let id : String?
    let isDeleted : Bool?
    let measurement : RemoteMeasurement?
    let medias : [RemoteMedias]?
    let name : String?
    let price : Double?
    let sellerName : String?
    let sold : Bool?
    let productPages: String?
    let reasonBanned: String?
}

struct RemoteChannel : Codable {
    let description : String?
    let id : String?
    let name : String?
    let photo : String?
    let isFollow: Bool?
    let code: String?
}
