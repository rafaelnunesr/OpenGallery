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
    
    @Test(arguments: [200, 201, 250, 298, 299])
    func load_deliversItemsOn2xxHTTPResponseWithJSONItems(statusCode: Int) {
        let (sut, client) = makeSUT()
        
        let (items, itemsJSON) = makeItemsJSON()
        
        let capturedResults = capturedResults(sut) {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: json)
        }
        
        #expect(capturedResults == [.success(items)])
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
    
    private func makeItem(
        id: Int = 1,
        title: String = "Some title",
        dateStart: (date: Date, iso8601: String),
        dateEnd: (date: Date, iso8601: String)? = nil,
        description: String = "some description",
        placeOfOrigin: String = "some place",
        artistID: Int = 1,
        artistTitle: String = "some artist",
        imageID: String = "some id",
        dimensionsDetails: [DimensionsDetails] = []
    ) -> (item: FeedItem, json: [String: Any?]) {
        let item = FeedItem(
            id: id,
            title: title,
            dateStart: dateStart.date,
            dateEnd: dateEnd?.date,
            description: description,
            dimensionsDetails: dimensionsDetails,
            placeOfOrigin: placeOfOrigin,
            artistID: artistID,
            artistTitle: artistTitle,
            imageID: imageID
        )
        
        
        let dimensionsDetailsJSON: [[String: Any?]] = dimensionsDetails.map {
            [
                "depth": $0.depth,
                "width": $0.width,
                "height": $0.height,
                "diameter": $0.diameter
            ]
        }
        
        let itemJSON: [String : Any?] = [
            "id": id,
            "title": title,
            "date_start": dateStart.iso8601,
            "date_end": dateEnd?.iso8601,
            "description": description,
            "dimensions_details": dimensionsDetailsJSON,
            "place_of_origin": placeOfOrigin,
            "artist_id": artistID,
            "artist_title": artistTitle,
            "image_id": imageID
        ]
        
        return (item, itemJSON)
    }
    
    private func makeItem1() -> (item: FeedItem, json: [String: Any?]) {
        makeItem(
            id: 1,
            title: "Some title",
            dateStart: (date: Date(timeIntervalSince1970: 1735689600), iso8601: "2025-01-01T00:00:00Z"),
            dateEnd: (date: Date(timeIntervalSince1970: 1738368540), iso8601: "2025-02-01T00:09:00Z"),
            description: "some description",
            placeOfOrigin: "some place",
            artistID: 1,
            artistTitle: "some artist",
            imageID: "some id",
            dimensionsDetails: [DimensionsDetails(depth: 1, width: 1, height: 1, diameter: 1)]
        )
    }
    
    private func makeItem2() -> (item: FeedItem, json: [String: Any?]) {
        makeItem(
            id: 1,
            title: "Some title",
            dateStart: (date: Date(timeIntervalSince1970: 1735776000), iso8601: "2025-01-02T00:00:00Z"),
            dateEnd: (date: Date(timeIntervalSince1970: 1736467200), iso8601: "2025-01-10T00:00:00Z"),
            description: "some description",
            placeOfOrigin: "some place",
            artistID: 1,
            artistTitle: "some artist",
            imageID: "some id",
            dimensionsDetails: [DimensionsDetails(depth: 1, width: 1, height: 1, diameter: 1)]
        )
    }
    
    private func makeItemsJSON() -> (items: [FeedItem], json: [String: Any?]) {
        let (item1, item1JSON) = makeItem1()
        let (item2, item2JSON) = makeItem2()
        
        let json = ["data": [item1JSON, item2JSON]]
        
        return ([item1, item2], json)
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
