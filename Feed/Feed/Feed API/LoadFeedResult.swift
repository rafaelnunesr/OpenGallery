//
//  LoadFeedResult.swift
//  Feed
//
//  Created by Rafael Rios on 28/12/25.
//

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
