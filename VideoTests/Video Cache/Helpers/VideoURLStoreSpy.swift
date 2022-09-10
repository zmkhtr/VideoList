//
//  VideoURLStoreSpy.swift
//  VideoTests
//
//  Created by PT.Koanba on 09/09/22.
//

import Foundation
import Video

class VideoURLStoreSpy: VideoURLStore {
    enum Message: Equatable {
        case insert(_ localURL: URL, for: URL)
        case retrieve(localVideoPathFor: URL)
    }
    
    private(set) var receivedMessages = [Message]()
    private var retrievalCompletions = [(VideoURLStore.RetrievalResult) -> Void]()
    private var insertionCompletions = [(VideoURLStore.InsertionResult) -> Void]()

    func insert(_ localUrl: URL, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(localUrl, for: url))
        insertionCompletions.append(completion)
    }
    
    func retrieve(videoPathForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(localVideoPathFor: url))
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with url: URL?, at index: Int = 0) {
        retrievalCompletions[index](.success(url))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}
