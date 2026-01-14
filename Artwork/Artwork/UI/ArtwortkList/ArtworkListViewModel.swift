//
//  ArtworkListViewModel.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

public struct ArtworkListViewData {
    let list: [ArtworkCardViewModel]
    
    public init(list: [ArtworkCardViewModel]) {
        self.list = list
    }
}

public protocol ArtworkListViewModelProtocol {
    var data: ArtworkListViewData { get set }
}

public class ArtworkListViewModel: ArtworkListViewModelProtocol {
    public var data: ArtworkListViewData
    private let loader: any ArtworkLoader
    
    public init(loader: any ArtworkLoader) {
        self.loader = loader
        
        data = .init(list: [])
        
        fetchArtworkData()
    }
    
    private func fetchArtworkData() {
        loader.load { _ in }
    }
}
