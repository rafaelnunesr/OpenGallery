//
//  FeedTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation
import Testing

class RemoteFeedLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.requestedURL = URL(string: "https://anyURL.com")
    }
}

class HTTPClient {
    var requestedURL: URL?
}

struct RemoteFeedLoaderTests {
    @Test func init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader(client: client)
        
        #expect(client.requestedURL == nil)
    }
    
    @Test func load_requestDataFromURL() {
        let client = HTTPClient()
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        
        #expect(client.requestedURL != nil)
    }
}
