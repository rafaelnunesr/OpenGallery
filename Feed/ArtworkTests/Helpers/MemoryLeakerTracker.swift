//
//  MemoryLeakerTracker.swift
//  Artwork
//
//  Created by Rafael Rios on 28/12/25.
//

import Testing

struct MemoryLeakTracker<T: AnyObject> {
    weak var instance: T?
    var sourceLocation: SourceLocation
    
    func verify() {
        #expect(instance == nil, "Expected \(instance) to be deallocated. Potential memory leak", sourceLocation: sourceLocation)
    }
}
