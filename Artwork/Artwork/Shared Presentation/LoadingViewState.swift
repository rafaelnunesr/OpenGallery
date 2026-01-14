//
//  LoadingViewState.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Combine

public protocol LoadingViewState: ObservableObject {
    var isLoading: Bool { get set }
}
