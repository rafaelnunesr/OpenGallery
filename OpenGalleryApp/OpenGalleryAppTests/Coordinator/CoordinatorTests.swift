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
    @Published var path = NavigationPath()
    
    init() {}
}

struct CoordinatorTests {
    @Test
    func whenInitialized_pathIsEmpty() {
        let sut = Coordinator()
        
        #expect(sut.path.isEmpty)
    }
}
