//
//  HTTPURLResponse.swift
//  Video
//
//  Created by PT.Koanba on 06/09/22.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
