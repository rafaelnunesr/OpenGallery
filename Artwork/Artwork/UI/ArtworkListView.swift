//
//  ArtworkListView.swift
//  Artwork
//
//  Created by Rafael Rios on 09/01/26.
//

import SwiftUI
import Combine

public enum ImageResult {
    case failure
    case success(Image)
}

public struct ArtworkListViewData {
    let list: [(model: ArtworkCardViewModel, imageResult: ImageResult)]
    
    public init(list: [(model: ArtworkCardViewModel, imageResult: ImageResult)]) {
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

public struct ArtworkListView<ViewModel: ArtworkListViewModelProtocol>: View {
    private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.data.list, id: \.model.id) { model in
                    ArtworkCardView(model: model.model, image: Color.red)
                }
            }
        }
        .navigationTitle("Artworks")
    }
}

#Preview {
    let model1 = ArtworkCardViewModel(
        id: "id_1",
        title: "A title",
        date: "400 BCE",
        description: "Some description",
        dimensions: "some dimension",
        placeOfOrigin: "some place",
        artist: "An artist"
    )
    
    let model2 = ArtworkCardViewModel(
        id: "id_2",
        title: "Another title",
        date: "300 BCE",
        description: "Another description",
        dimensions: "another dimension",
        placeOfOrigin: "another place",
        artist: "Another artist"
    )
    
    let imageResult = ImageResult.failure
    
    let data = ArtworkListViewData(list: [(model1, imageResult) , (model2, imageResult)])
    NavigationStack {
        ArtworkListView(viewModel: ArtworkListViewModel(data: data))
    }
}
