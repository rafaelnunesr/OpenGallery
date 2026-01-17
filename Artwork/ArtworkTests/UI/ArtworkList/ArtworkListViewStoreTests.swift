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
    func whenLoaderReturnsError_stateShouldBeUpdatedCorrectly() {
        let loader = ArtworkLoaderSpy()
        let sut = ArtworkListViewStore(loader: loader)
        
        loader.completeWithError()
        
        #expect(sut.errorMessage == "GENERIC ERROR MESSAGE")
        #expect(!sut.isLoading)
    }
    
    @Test
    func whenLoaderReturnsSuccess_stateShouldBeUpdatedCorrectly() {
        let loader = ArtworkLoaderSpy()
        let sut = ArtworkListViewStore(loader: loader)
        
        loader.completeWithSuccess()
        
        #expect(!sut.value.isEmpty)
        #expect(sut.errorMessage == nil)
        #expect(!sut.isLoading)
    }
    
    @Test
    func reload_triggersLoaderLoadMethod() {
        let loader = ArtworkLoaderSpy()
        let sut = ArtworkListViewStore(loader: loader)
        
        #expect(loader.methodInvocations == [.load])
        
        sut.reload()
        
        #expect(loader.methodInvocations == [.load, .load])
        
        sut.reload()
        
        #expect(loader.methodInvocations == [.load, .load, .load])
    }
    
    // MARK: - Helper
    
    private class ArtworkLoaderSpy: ArtworkLoader {
        private(set) var messages = [((LoadArtworkResult) -> Void)]()
        private(set) var methodInvocations = [MethodName]()
        
        enum MethodName {
            case load
        }
        
        enum Error: Swift.Error {}
        
        func load(completion: @escaping (LoadArtworkResult) -> Void) {
            messages.append(completion)
            methodInvocations.append(.load)
        }
        
        func completeWithError(at index: Int = 0) {
            messages[index](.failure(anyNSError()))
        }
        
        func completeWithSuccess(at index: Int = 0) {
            messages[index](.success([ArtworkItem.makeItem1().item]))
        }
    }
}
