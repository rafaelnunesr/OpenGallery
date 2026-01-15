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
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.value) { model in
                    ArtworkCardView(model: model)
                }
            }
        }
        .navigationTitle("Artworks")
    }
}

#Preview {
    NavigationStack {
        ArtworkListView(store: ArtworkListViewStore(loader: ArtworkLoaderDummy()))
    }
}
