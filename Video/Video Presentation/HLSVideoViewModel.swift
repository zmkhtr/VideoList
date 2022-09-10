//
//  HLSVideoViewModel.swift
//  Video
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import AVFoundation

public struct HLSVideoViewModel {
    public let playerItem: AVPlayerItem?
    public let isLoading: Bool
    public let shouldRetry: Bool
}

