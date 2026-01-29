//
//  Coordinator.swift
//  OpenGalleryApp
//
//  Created by Rafael Rios on 29/01/26.
//

import Combine

class Coordinator<T: Hashable> {
    @Published var path: [T] = []
    
    init() {}
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func push(_ element: T) {
        guard !path.contains(element) else { return }
        path.append(element)
    }
    
    func popToRoot() {
        path = []
    }
}
