//
//  ArtworkAPIEndToEndTests.swift
//  ArtworkAPIEndToEndTests
//
//  Created by Rafael Rios on 01/01/26.
//

import Artwork
import Foundation
import Testing

@Suite(.timeLimit(.minutes(1)))
final class ArtworkAPIEndToEndTests {
    private var clientTracker: MemoryLeakTracker<URLSessionHTTPClient>?
    private var loaderTracker: MemoryLeakTracker<RemoteArtworkLoader>?

    @Test
    func endToEndTestServerGETArtworkResult() async {
        let receivedResult = await getArtworkResult()
        
        guard case let .success(items) = receivedResult else {
            Issue.record("Expected success result, got \(receivedResult)")
            return
        }
        
        #expect(!items.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func getArtworkResult(
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) async -> LoadArtworkResult? {
        let loader = makeSUT()
        
        var receivedResult: LoadArtworkResult?
        
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
    ) -> any ArtworkLoader {
        let url = URL(string: "https://api.artic.edu/api/v1/artworks?page=1&limit=1")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteArtworkLoader(url: url, client: client)
        
        let sourceLocation = SourceLocation(fileID: #fileID, filePath: filePath, line: line, column: column)
        clientTracker = MemoryLeakTracker(instance: client, sourceLocation: sourceLocation)
        loaderTracker = MemoryLeakTracker(instance: loader, sourceLocation: sourceLocation)
        
        return loader
    }
}
