//
//  Helpers.swift
//  Feed
//
//  Created by Rafael Rios on 30/12/25.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func invalidJSONData() -> Data {
    Data("invalid json".utf8)
}

func anyData() -> Data {
    Data("any data".utf8)
}

func anyHTTPURLResponse() -> HTTPURLResponse? {
    HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
}

func nonHTTPURLResponse() -> URLResponse {
    URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}
