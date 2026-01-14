//
//  ErrorViewState.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Combine

public protocol ErrorViewState: ObservableObject {
    var errorMessage: String? { get set }
}
