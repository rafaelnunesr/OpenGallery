//
//  FeedAPIEndToEndTests.swift
//  FeedAPIEndToEndTests
//
//  Created by Rafael Rios on 01/01/26.
//

import Feed
import Foundation
import Testing

final class FeedAPIEndToEndTests {
    private var clientTracker: MemoryLeakTracker<URLSessionHTTPClient>?
    private var loaderTracker: MemoryLeakTracker<RemoteFeedLoader>?

    @Test func endToEndTestServerGETFeedResult() async {
        let receivedResult = await getFeedResult()
        
        guard case let .success(items) = receivedResult else {
            Issue.record("Expected success result, got \(receivedResult)")
            return
        }
        
        #expect(!items.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) async -> LoadFeedResult? {
        let loader = makeSUT()
        
        var receivedResult: LoadFeedResult?
        
        await withCheckedContinuation { continuation in
            loader.load { result in
                receivedResult = result
                continuation.resume()
            }
        }
        
        return receivedResult
    }
    
    private func makeSUT(
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) -> any FeedLoader {
        let url = URL(string: "https://api.artic.edu/api/v1/artworks?page=1&limit=1")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: url, client: client)
        
        let sourceLocation = SourceLocation(fileID: #fileID, filePath: filePath, line: line, column: column)
        clientTracker = MemoryLeakTracker(instance: client, sourceLocation: sourceLocation)
        loaderTracker = MemoryLeakTracker(instance: loader, sourceLocation: sourceLocation)
        
        return loader
    }
}
