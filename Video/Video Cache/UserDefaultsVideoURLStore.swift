//
//  UserDefaultsVideoURLStore.swift
//  Video
//
//  Created by PT.Koanba on 09/09/22.
//

import Foundation

public final class UserDefaultsVideoURLStore: VideoURLStore {
    
    private let userDefaults: UserDefaults
    
    enum StoreError: Error {
        case failedToInsertData
        case failedToLoadUserDefaults(Error)
    }
    
    private let failedToLoadUserDefaultsErrorMessage = NSError(
        domain: "Failed to load UserDefaults",
        code: 404)
    
    public init(userDefaults: UserDefaults?) throws {
        guard let userDefaults = userDefaults else {
            throw StoreError.failedToLoadUserDefaults(failedToLoadUserDefaultsErrorMessage)
        }
        self.userDefaults = userDefaults
    }
    
    public func insert(_ localPath: String, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        let key = url.absoluteString
        userDefaults.set(localPath, forKey: key)
        if userDefaults.object(forKey: key) != nil {
            completion(.success(()))
        } else {
            completion(.failure(StoreError.failedToInsertData))
        }
    }
    
    public func retrieve(videoPathForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        if let videoPath = userDefaults.string(forKey: url.absoluteString) {
            completion(.success(videoPath))
        } else {
            completion(.success(.none))
        }
    }
}
