//
//  FeedTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation
import Testing
import Feed

final class RemoteFeedLoaderTests {
    private var sutTracker: MemoryLeakTracker<RemoteFeedLoader>?
    
    deinit {
        sutTracker?.verify()
    }
    
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
        
        #expect(assertEqual(actual: capturedResults, expected: [.failure(.connectivity)]))
    }
    
    @Test(arguments: [198, 199, 300, 301, 400, 500])
    func load_deliversErrorOnNon2xxHTTPResponse(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            client.complete(withStatusCode: statusCode)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [.failure(.invalidData)]))
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversErrorOn2xxHTTPResponseWithInvalidJSON(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: statusCode, data: invalidJSON)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [.failure(.invalidData)]))
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let emptyListJSONData = makeJSONData(json: FeedItem.makeEmptyJSON())
            client.complete(withStatusCode: statusCode, data: emptyListJSONData)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [.success([])]))
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversItemsOn2xxHTTPResponseWithJSONItems(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let (items, itemsJSON) = FeedItem.makeItemsJSON()
        
        let capturedResults = capturedResults(sut) {
            let data = makeJSONData(json: itemsJSON)
            client.complete(withStatusCode: statusCode, data: data)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [.success(items)]))
    }
    
    @Test
    func load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://anyURL.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeJSONData(json: FeedItem.makeEmptyJSON()))
        
        #expect(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://anyURL.com")!,
                         filePath: String = #file,
                         line: Int = #line,
                         column: Int = #column) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        let sourceLocation = SourceLocation(fileID: #fileID, filePath: filePath, line: line, column: column)
        sutTracker = MemoryLeakTracker(instance: sut, sourceLocation: sourceLocation)
        
        return (sut, client)
    }
    
    private func makeJSONData(json: [String : Any?]) -> Data {
        try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func capturedResults(_ sut: RemoteFeedLoader, when action: () -> Void) -> [RemoteFeedLoader.Result] {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        action()
        
        return capturedResults
    }
    
    private func assertEqual(actual: [RemoteFeedLoader.Result], expected: [RemoteFeedLoader.Result]) -> Bool {
        guard actual.count == expected.count else { return false }
        
        return zip(actual, expected).allSatisfy { actualResult, expectedResult in
            switch (actualResult, expectedResult) {
                
            case let (.success(actualItems), .success(expectedItems)):
                return actualItems == expectedItems
                
            case let (.failure(actualError), .failure(expectedError)):
                return actualError == expectedError
                
            default:
                return false
            }
        }
        
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
