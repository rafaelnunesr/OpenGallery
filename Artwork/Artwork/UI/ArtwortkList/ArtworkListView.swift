//
//  ArtworkListView.swift
//  Artwork
//
//  Created by Rafael Rios on 09/01/26.
//

import SwiftUI

public struct ArtworkListView<ViewModel: ArtworkListViewModelProtocol>: View {
    private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.data.list) { model in
                    ArtworkCardView(model: model)
                }
            }
        }
        .navigationTitle("Artworks")
    }
}

#Preview {
    let anyURL = URL(string: "https://any-url.com")!
    
    let model1 = ArtworkCardViewModel(
        id: "id_1",
        title: "A title",
        date: "400 BCE",
        description: "Some description",
        dimensions: "some dimension",
        placeOfOrigin: "some place",
        artist: "An artist",
        imageURL: anyURL
    )
    
    let model2 = ArtworkCardViewModel(
        id: "id_2",
        title: "Another title",
        date: "300 BCE",
        description: "Another description",
        dimensions: "another dimension",
        placeOfOrigin: "another place",
        artist: "Another artist",
        imageURL: anyURL
    )
    
    let imageResult = ImageResult.failure
    
    let data = ArtworkListViewData(list: [model1, model2])
    NavigationStack {
        ArtworkListView(viewModel: ArtworkListViewModel(data: data))
    }
}
