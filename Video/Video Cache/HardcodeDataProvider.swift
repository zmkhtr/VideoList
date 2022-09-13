//
//  HardcodeDataProvider.swift
//  Video
//
//  Created by PT.Koanba on 13/09/22.
//

import Foundation

public class HardcodeDataProvider {
    public static func getVideos() -> [Video] {
        [
            "https://asset.kipaskipas.com/media/stream/1652708934197/1652708934197.m3u8",
            "https://asset.kipaskipas.com/media/stream/1661315766025/1661315766025.m3u8",
            "https://asset.kipaskipas.com/media/stream/1645279110994/1645279110994.m3u8",
            "https://asset.kipaskipas.com/media/stream/1652967612670/1652967612670.m3u8",
            "https://asset.kipaskipas.com/media/stream/1636342355589/1636342355589.m3u8",
            "https://asset.kipaskipas.com/media/stream/1662433174719/1662433174719.m3u8",
            "https://asset.kipaskipas.com/media/stream/1640832526293/1640832526293.m3u8",
            "https://asset.kipaskipas.com/media/stream/1660289515109/1660289515109.m3u8",
            "https://asset.kipaskipas.com/media/stream/1650981250172/1650981250172.m3u8",
            "https://asset.kipaskipas.com/media/stream/1648030249792/1648030249792.m3u8",
            "https://asset.kipaskipas.com/media/stream/1659413373557/1659413373557.m3u8",
            "https://asset.kipaskipas.com/media/stream/1641365159432/1641365159432.m3u8",
            "https://asset.kipaskipas.com/media/stream/1660533958921/1660533958921.m3u8",
            "https://asset.kipaskipas.com/media/stream/1650357920968/1650357920968.m3u8",
            "https://asset.kipaskipas.com/media/stream/1652925041338/1652925041338.m3u8",
            "https://asset.kipaskipas.com/media/stream/1643774994905/1643774994905.m3u8",
            "https://asset.kipaskipas.com/media/stream/1662305366897/1662305366897.m3u8",
            "https://asset.kipaskipas.com/media/stream/1645792868788/1645792868788.m3u8",
            "https://asset.kipaskipas.com/media/stream/1653890871105/1653890871105.m3u8",
            "https://asset.kipaskipas.com/media/stream/1648030330405/1648030330405.m3u8",
            "https://asset.kipaskipas.com/media/stream/1648803373703/1648803373703.m3u8",
            "https://asset.kipaskipas.com/media/stream/1639541979813/1639541979813.m3u8",
            "https://asset.kipaskipas.com/media/stream/1660882055107/1660882055107.m3u8",
            "https://asset.kipaskipas.com/media/stream/1643951380486/1643951380486.m3u8"
        ].map { hlsURL in
            Video(id: UUID().uuidString, hlsURL: URL(string: hlsURL)!)
        }
    }
}
