//
//  ArtworkListView.swift
//  Artwork
//
//  Created by Rafael Rios on 09/01/26.
//

import SwiftUI

public struct ArtworkListView<Store: ArtworkListViewStoreProtocol>: View {
    private var store: Store
    
    public init(store: Store) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 8) {
            contentView
            loadingView
        }
        .navigationTitle("Artworks")
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.value) { model in
                    ArtworkCardView(model: model)
                }
            }
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if store.isLoading {
            ProgressView()
        }
    }
}

#Preview {
    NavigationStack {
        ArtworkListView(store: ArtworkListViewStore(loader: ArtworkLoaderDummy()))
    }
}
