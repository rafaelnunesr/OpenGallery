//
//  FeedTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation
import Testing
import Feed

struct RemoteFeedLoaderTests {
    @Test func init_doesNotRequestDataFromURL() {
        let client = makeSUT().client
        
        #expect(client.requestedURLs.isEmpty)
    }
    
    @Test func load_requestsDataFromURL() {
        let url = URL(string: "https://anyURL.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        #expect(client.requestedURLs == [url])
    }
    
    @Test func loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://anyURL.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        #expect(client.requestedURLs == [url, url])
    }
    
    @Test func load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
        
        #expect(capturedResults == [.failure(.connectivity)])
    }
    
    @Test(arguments: [198, 199, 300, 301, 400, 500])
    func load_deliversErrorOnNon2xxHTTPResponse(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            client.complete(withStatusCode: statusCode)
        }
        
        #expect(capturedResults == [.failure(.invalidData)])
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversErrorOn2xxHTTPResponseWithInvalidJSON(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: statusCode, data: invalidJSON)
        }
        
        #expect(capturedResults == [.failure(.invalidData)])
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let emptyListJSON = Data("{\"data\": []}".utf8)
            client.complete(withStatusCode: statusCode, data: emptyListJSON)
        }
        
        #expect(capturedResults == [.success([])])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://anyURL.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    private func capturedResults(_ sut: RemoteFeedLoader, when action: () -> Void) -> [RemoteFeedLoader.Result] {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        action()
        
        return capturedResults
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            
            messages[index].completion(.success(data, response))
        }
    }
}
