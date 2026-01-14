//
//  ArtworkTests.swift
//  ArtworkTests
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation
import Testing
import Artwork

final class RemoteArtworkLoaderTests {
    private var sutTracker: MemoryLeakTracker<RemoteArtworkLoader>?
    
    deinit {
        sutTracker?.verify()
    }
    
    @Test
    func init_doesNotRequestDataFromURL() {
        let client = makeSUT().client
        
        #expect(client.requestedURLs.isEmpty)
    }
    
    @Test
    func load_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        #expect(client.requestedURLs == [url])
    }
    
    @Test
    func loadTwice_requestsDataFromURLTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        #expect(client.requestedURLs == [url, url])
    }
    
    @Test
    func load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            client.complete(with: anyNSError())
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [failure(.connectivity)]))
    }
    
    @Test(arguments: [198, 199, 300, 301, 400, 500])
    func load_deliversErrorOnNon2xxHTTPResponse(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            client.complete(withStatusCode: statusCode)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [failure(.invalidData)]))
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversErrorOn2xxHTTPResponseWithInvalidJSON(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let invalidJSON = invalidJSONData()
            client.complete(withStatusCode: statusCode, data: invalidJSON)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [failure(.invalidData)]))
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let capturedResults = capturedResults(sut) {
            let emptyListJSONData = makeJSONData(json: ArtworkItem.makeEmptyJSON())
            client.complete(withStatusCode: statusCode, data: emptyListJSONData)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [.success([])]))
    }
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversItemsOn2xxHTTPResponseWithJSONItems(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let (items, itemsJSON) = ArtworkItem.makeItemsJSON()
        
        let capturedResults = capturedResults(sut) {
            let data = makeJSONData(json: itemsJSON)
            client.complete(withStatusCode: statusCode, data: data)
        }
        
        #expect(assertEqual(actual: capturedResults, expected: [.success(items)]))
    }
    
    @Test
    func load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: RemoteArtworkLoader? = RemoteArtworkLoader(url: url, client: client)
        
        var capturedResults = [RemoteArtworkLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeJSONData(json: ArtworkItem.makeEmptyJSON()))
        
        #expect(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = anyURL(),
                         filePath: String = #file,
                         line: Int = #line,
                         column: Int = #column) -> (sut: RemoteArtworkLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteArtworkLoader(url: url, client: client)
        
        let sourceLocation = SourceLocation(fileID: #fileID, filePath: filePath, line: line, column: column)
        sutTracker = MemoryLeakTracker(instance: sut, sourceLocation: sourceLocation)
        
        return (sut, client)
    }
    
    private func makeJSONData(json: [String : Any?]) -> Data {
        try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func capturedResults(_ sut: RemoteArtworkLoader, when action: () -> Void) -> [RemoteArtworkLoader.Result] {
        var capturedResults = [RemoteArtworkLoader.Result]()
        sut.load { capturedResults.append($0) }
        action()
        
        return capturedResults
    }
    
    private func failure(_ error: RemoteArtworkLoader.Error) -> RemoteArtworkLoader.Result {
        .failure(error)
    }
    
    private func assertEqual(actual: [RemoteArtworkLoader.Result], expected: [RemoteArtworkLoader.Result]) -> Bool {
        guard actual.count == expected.count else { return false }
        
        return zip(actual, expected).allSatisfy { actualResult, expectedResult in
            switch (actualResult, expectedResult) {
                
            case let (.success(actualItems), .success(expectedItems)):
                return actualItems == expectedItems
                
            case let (.failure(actualError as RemoteArtworkLoader.Error), .failure(expectedError as RemoteArtworkLoader.Error)):
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
