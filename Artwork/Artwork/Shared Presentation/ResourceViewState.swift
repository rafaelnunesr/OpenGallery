//
//  ResourceViewState.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Combine

public protocol ResourceViewState: ObservableObject {
    associatedtype ResourceValue
    var value: ResourceValue { get set }
}
