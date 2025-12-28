//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 28/12/25.
//

import Foundation
import Testing

import Feed

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
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.makeDataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct URLSessionHTTPClientTests {
    @Test
    func getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { _ in }
        
        #expect(task.resumeCallCount == 1)
    }
    
    @Test
    func getFromURL_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy()
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                #expect(receivedError == error)
            default:
                Issue.record("Expected failure with error \(error), got \(result) instead")
            }
            
        }
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSessionProtocol {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPDataTask
            let error: Error?
        }
        
        func stub(url: URL, task: HTTPDataTask = DummyURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func makeDataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couln't find stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            return stub.task
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
