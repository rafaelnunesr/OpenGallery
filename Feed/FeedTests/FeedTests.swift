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
    private let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.requestedURL = url
    }
}

class HTTPClient {
    var requestedURL: URL?
}

struct RemoteFeedLoaderTests {
    @Test func init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://anyURL.com")!
        let client = HTTPClient()
        _ = RemoteFeedLoader(url: url, client: client)
        
        #expect(client.requestedURL == nil)
    }
    
    @Test func load_requestDataFromURL() {
        let url = URL(string: "https://anyURL.com")!
        let client = HTTPClient()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        sut.load()
        
        #expect(client.requestedURL == url)
    }
}
