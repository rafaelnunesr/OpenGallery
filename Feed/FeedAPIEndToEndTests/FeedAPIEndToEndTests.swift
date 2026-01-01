//
//  FeedAPIEndToEndTests.swift
//  FeedAPIEndToEndTests
//
//  Created by Rafael Rios on 01/01/26.
//

import Feed
import Foundation
import Testing

struct FeedAPIEndToEndTests {

    @Test func endToEndTestServerGETFeedResult() async {
        let receivedResult = await getFeedResult()
        
        guard case let .success(items) = receivedResult else {
            Issue.record("Expected success result, got \(receivedResult)")
            return
        }
        
        #expect(!items.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func getFeedResult() async -> LoadFeedResult? {
        let url = URL(string: "https://api.artic.edu/api/v1/artworks?page=1&limit=1")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: url, client: client)
        
        var receivedResult: LoadFeedResult?
        
        await withCheckedContinuation { continuation in
            loader.load { result in
                receivedResult = result
                continuation.resume()
            }
        }
        
        return receivedResult
    }
}
