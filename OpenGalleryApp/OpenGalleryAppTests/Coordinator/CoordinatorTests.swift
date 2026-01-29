//
//  CoordinatorTests.swift
//  OpenGalleryApp
//
//  Created by Rafael Rios on 29/01/26.
//

import Testing

import SwiftUI
import Combine

class Coordinator {
    @Published var path: [any Hashable] = []
    
    init() {}
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}

struct CoordinatorTests {
    @Test
    func whenInitialized_pathIsEmpty() {
        let sut = Coordinator()
        
        #expect(sut.path.isEmpty)
    }
    
    @Test
    func whenPathIsEmpty_popKeepsPathEmpty() {
        let sut = Coordinator()
        
        sut.pop()
        
        #expect(sut.path.isEmpty)
    }
    
    @Test
    func popRemovesLastElementFromPath() {
        let sut = Coordinator()
        
        sut.path.append("A value")
        
        sut.pop()
        
        #expect(sut.path.isEmpty)
    }
}
