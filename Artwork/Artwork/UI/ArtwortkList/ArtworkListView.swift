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
    NavigationStack {
        ArtworkListView(viewModel: ArtworkListViewModel(loader: ArtworkLoaderDummy()))
    }
}
