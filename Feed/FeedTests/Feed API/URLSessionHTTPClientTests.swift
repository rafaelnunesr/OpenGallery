//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by Rafael Rios on 28/12/25.
//

import Foundation
import Testing

import Feed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct URLSessionHTTPClientTests {
    
    @Test
    func getFromURL_failsOnRequestError() async {
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        
        let result = await awaitResult(from: sut, url: url)
        
        guard case let .failure(receivedError as NSError) = result else {
            Issue.record("Expected failure with NSError \(error), got \(result)")
            return
        }

        #expect(receivedError.domain == error.domain)
        #expect(receivedError.code == error.code)
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    @Test
    func getFromURL_performGETRequestsWithURL() async {
        URLProtocolStub.startInterceptingRequests()
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        
        var capturedRequests = [URLRequest]()
        URLProtocolStub.observeRequests { capturedRequests.append($0) }
        
        await awaitResult(from: sut, url: url)
        
        #expect(capturedRequests[0].url == url)
        #expect(capturedRequests[0].httpMethod == "GET")
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    // MARK: - Helpers
    
    @discardableResult
    private func awaitResult(from sut: URLSessionHTTPClient, url: URL) async -> HTTPClientResult {
        await withCheckedContinuation { continuation in
            sut.get(from: url) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(_ closure: @escaping (URLRequest) -> Void) {
            requestObserver = closure
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
