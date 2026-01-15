//
//  ArtworkListViewStore.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import Foundation
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
        
        loader.load { [weak self] result in
            switch result {
            case .failure:
                self?.errorMessage = "GENERIC ERROR MESSAGE"
            case let .success(models):
                self?.value = models.map { ArtworkCardViewModel.map(from: $0) }
            }
            
            self?.isLoading = false
        }
    }
    
    public func reload() {}
}

extension ArtworkCardViewModel {
    static func map(from item: ArtworkItem) -> Self {
        ArtworkCardViewModel(
            id: String(item.id),
            title: item.title,
            date: item.dateDisplay,
            description: item.description,
            dimensions: "",
            placeOfOrigin: item.placeOfOrigin,
            artist: item.artistTitle,
            imageURL: URL(string: "https://any-url.com")!
        )
    }
}
