//
//  ArtworkListViewStore.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import Combine

public protocol ArtworkListViewStoreProtocol: ResourceViewState, LoadingViewState, ErrorViewState {
    var value: [ArtworkCardViewModel] { get }
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    func reload()
}

public class ArtworkListViewStore: ArtworkListViewStoreProtocol {
    @Published public var value = [ArtworkCardViewModel]()
    @Published public var isLoading = false
    @Published public var errorMessage: String? = nil
    
    private let loader: any ArtworkLoader
    
    public init(loader: any ArtworkLoader) {
        self.loader = loader
        
        fetchArtworkData()
    }
    
    private func fetchArtworkData() {
        isLoading = true
        
        loader.load { [weak self] _ in
            self?.errorMessage = "GENERIC ERROR MESSAGE"
        }
    }
    
    public func reload() {}
}
