//
//  ArtworkListViewModelTests.swift
//  Artwork
//
//  Created by Rafael Rios on 13/01/26.
//

import Testing
import Artwork

struct ArtworkListViewModelTests {
    
    @Test
    func request_dataWhenLoaded() {
        let loader = ArtworkLoaderSpy()
        _ = ArtworkListViewStore(loader: loader)
        
        #expect(!loader.messages.isEmpty)
    }
    
    private class ArtworkLoaderSpy: ArtworkLoader {
        var messages = [((LoadArtworkResult) -> Void)]()
        
        enum Error: Swift.Error {}
        
        func load(completion: @escaping (LoadArtworkResult) -> Void) {
            messages.append(completion)
        }
    }
}
