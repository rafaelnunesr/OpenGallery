//
//  CoordinatorTests.swift
//  OpenGalleryApp
//
//  Created by Rafael Rios on 29/01/26.
//

import Testing

import SwiftUI
import Combine

class Coordinator<T: Hashable> {
    @Published var path: [T] = []
    
    init() {}
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func push(_ view: T) {
        guard !path.contains(view) else { return }
        path.append(view)
    }
}

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
    
    // MARK: Helpers
    
    private func makeSUT() -> Coordinator<String> {
        return Coordinator()
    }
}
