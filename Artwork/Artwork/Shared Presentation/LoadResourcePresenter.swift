//
//  LoadResourcePresenter.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Combine

public protocol ResourceViewState: ObservableObject {
    associatedtype ResourceValue
    var value: ResourceValue { get set }
}

public protocol LoadingViewState: ObservableObject {
    var isLoading: Bool { get set }
}

public protocol ErrorViewState: ObservableObject {
    var errorMessage: String? { get set }
}

public class LoadResourcePresenter<Resource, View: ResourceViewState> {
    public typealias Mapper = (Resource) throws -> View.ResourceValue
    
    private var resourceViewState: View
    private let loadingViewState: any LoadingViewState
    private let errorViewState: any ErrorViewState
    private let mapper: Mapper
    
    public init(
        resourceViewState: View,
        loadingViewState: any LoadingViewState,
        errorViewState: any ErrorViewState,
        mapper: @escaping Mapper
    ) {
        self.resourceViewState = resourceViewState
        self.loadingViewState = loadingViewState
        self.errorViewState = errorViewState
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        loadingViewState.isLoading = true
        errorViewState.errorMessage = nil
    }
    
    public func didFinishLoading(with resource: Resource) {
        do {
            resourceViewState.value = try mapper(resource)
            loadingViewState.isLoading = false
            errorViewState.errorMessage = nil
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    public func didFinishLoading(with error: Error) {
        loadingViewState.isLoading = false
        errorViewState.errorMessage = "GENERIC ERROR VALUE"
    }
}
