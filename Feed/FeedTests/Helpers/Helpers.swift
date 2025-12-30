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
