//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 28/12/25.
//

import Foundation
import Testing

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}

struct URLSessionHTTPClientTests {
    @Test
    func getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        #expect(session.receivedURLs == [url])
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSession, @unchecked Sendable {
        var receivedURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {}
}
