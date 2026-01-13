//
//  LoadArtworkResult.swift
//  Artwork
//
//  Created by Rafael Rios on 28/12/25.
//

public enum LoadArtworkResult {
    case success([ArtworkItem])
    case failure(Error)
}

public protocol ArtworkLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadArtworkResult) -> Void)
}

class ArtworkLoaderDummy: ArtworkLoader {
    enum Error: Swift.Error {}
    
    init() {}
    
    func load(completion: @escaping (LoadArtworkResult) -> Void) {}
}
