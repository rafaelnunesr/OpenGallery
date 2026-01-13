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

class ArtworkListViewModel: ArtworkListViewModelProtocol {
    var data: ArtworkListViewData
    
    init(data: ArtworkListViewData = ArtworkListViewData(list: [])) {
        self.data = data
    }
}
