//
//  FeedTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation
import Testing

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

struct RemoteFeedLoaderTests {
    @Test func init_doesNotRequestDataFromURL() async throws {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        #expect(client.requestedURL == nil)
    }
}
