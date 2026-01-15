//
//  ArtworkListViewStoreTests.swift
//  Artwork
//
//  Created by Rafael Rios on 13/01/26.
//

import Testing
import Artwork

struct ArtworkListViewStoreTests {
    
    @Test
    func init_requestsData() {
        let loader = ArtworkLoaderSpy()
        _ = ArtworkListViewStore(loader: loader)
        
        #expect(!loader.messages.isEmpty)
    }
    
    @Test
    func init_setIsLoadingAsTrue() {
        let sut = ArtworkListViewStore(loader: ArtworkLoaderSpy())
        
        #expect(sut.isLoading)
    }
    
    @Test
    func test_whenLoaderReturnsError_stateShouldBeUpdatedCorrectly() {
        let loader = ArtworkLoaderSpy()
        let sut = ArtworkListViewStore(loader: loader)
        
        loader.completeWithError()
        
        #expect(sut.errorMessage == "GENERIC ERROR MESSAGE")
        #expect(!sut.isLoading)
    }
    
    @Test
    func test_whenLoaderReturnsSuccess_stateShouldBeUpdatedCorrectly() {
        let loader = ArtworkLoaderSpy()
        let sut = ArtworkListViewStore(loader: loader)
        
        loader.completeWithSuccess()
        
        #expect(!sut.value.isEmpty)
        #expect(sut.errorMessage == nil)
        #expect(!sut.isLoading)
    }
    
    // MARK: - Helper
    
    private class ArtworkLoaderSpy: ArtworkLoader {
        var messages = [((LoadArtworkResult) -> Void)]()
        
        enum Error: Swift.Error {}
        
        func load(completion: @escaping (LoadArtworkResult) -> Void) {
            messages.append(completion)
        }
        
        func completeWithError(at index: Int = 0) {
            messages[index](.failure(anyNSError()))
        }
        
        func completeWithSuccess(at index: Int = 0) {
            messages[index](.success([ArtworkItem.makeItem1().item]))
        }
    }
}
