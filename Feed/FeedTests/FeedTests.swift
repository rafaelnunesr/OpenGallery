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
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error, response in
            guard response != nil else {
                completion(.connectivity)
                return
            }
            
            completion(.invalidData)
        }
    }
}

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

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
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
    
        #expect(capturedErrors == [.connectivity])
    }
    
    @Test func load_deliversErrorOnNon2xxHTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [198, 199, 300, 301, 400, 500]
        
        samples.enumerated().forEach { index, code in
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { capturedErrors.append($0) }
            
            client.complete(withStatusCode: code, at: index)
            #expect(capturedErrors == [.invalidData])
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://anyURL.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )
            
            messages[index].completion(nil, response)
        }
    }
}
