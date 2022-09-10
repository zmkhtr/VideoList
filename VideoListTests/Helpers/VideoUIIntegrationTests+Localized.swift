//
//  VideoUIIntegrationTests+Localized.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import Foundation
import XCTest
import Video

extension VideoUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Video"
        let bundle = Bundle(for: VideoPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
