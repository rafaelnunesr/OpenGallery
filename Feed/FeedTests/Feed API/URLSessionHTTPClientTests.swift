//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 28/12/25.
//

import Foundation
import Testing

protocol URLSessionProtocol {
    func makeDataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPDataTask
}

protocol HTTPDataTask {
    func resume()
}

extension URLSessionDataTask: HTTPDataTask {}

extension URLSession: URLSessionProtocol {
    func makeDataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPDataTask {
        dataTask(with: url, completionHandler: completionHandler)
    }
}

class URLSessionHTTPClient {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(from url: URL) {
        _ = session.makeDataTask(with: url) { _, _, _ in }.resume()
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
    
    @Test
    func getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        #expect(task.resumeCallCount == 1)
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSessionProtocol {
        var receivedURLs = [URL]()
        private var stubs = [URL: HTTPDataTask]()
        
        func stub(url: URL, task: HTTPDataTask) {
            stubs[url] = task
        }
        
        func makeDataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPDataTask {
            receivedURLs.append(url)
            return stubs[url] ?? DummyURLSessionDataTask()
        }
    }
    
    private final class DummyURLSessionDataTask: HTTPDataTask {
        func resume() {}
    }
    
    private class URLSessionDataTaskSpy: HTTPDataTask {
        var resumeCallCount = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
