//
//  VideoItemsMapper.swift
//  Video
//
//  Created by PT.Koanba on 05/09/22.
//

import Foundation

public final class VideoItemsMapper {

    private struct Root: Decodable {
        private let code, message: String
        private let data: RemoteFeedItem
        
        var videos: [Video] {
            data.content.map {
                Video(
                    id: $0.post.medias[0].id,
                    hlsURL: $0.post.medias[0].hlsUrl
                )
            }
        }
        
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Video] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteVideoLoader.Error.invalidData
        }
     
        return root.videos
    }
}
