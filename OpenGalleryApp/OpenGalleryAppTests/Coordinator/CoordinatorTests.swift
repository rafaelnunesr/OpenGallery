//
//  CoordinatorTests.swift
//  OpenGalleryApp
//
//  Created by Rafael Rios on 29/01/26.
//

import Testing
@testable import OpenGalleryApp

struct CoordinatorTests {
    @Test
    func whenInitialized_pathIsEmpty() {
        let sut = makeSUT()
        
        #expect(sut.path.isEmpty)
    }
    
    @Test
    func whenPathIsEmpty_popKeepsPathEmpty() {
        let sut = makeSUT()
        
        sut.pop()
        
        #expect(sut.path.isEmpty)
    }
    
    @Test
    func popRemovesLastElementFromPath() {
        let sut = makeSUT()
        
        sut.path.append("A value")
        
        sut.pop()
        
        #expect(sut.path.isEmpty)
    }
    
    @Test
    func pushAddsElementToPath() {
        let sut = makeSUT()
        
        sut.push("A value")
        
        #expect(sut.path.map { $0 } == ["A value"])
    }
    
    @Test
    func pushDoesNotAddDuplicateElements() {
        let sut = makeSUT()
        
        sut.push("A value")
        sut.push("A value")
        
        #expect(sut.path.map { $0 } == ["A value"])
    }
    
    @Test
    func popToRoot_clearsPath() {
        let sut = makeSUT()
        
        sut.path.append("A value")
        sut.path.append("Another value")
        
        sut.popToRoot()
        
        #expect(sut.path.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> Coordinator<String> {
        return Coordinator()
    }
}
