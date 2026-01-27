//
//  ArtworkListView.swift
//  Artwork
//
//  Created by Rafael Rios on 09/01/26.
//

import SwiftUI

public struct ArtworkListView<Store: ArtworkListViewStoreProtocol>: View {
    @ObservedObject private var store: Store
    
    public init(store: Store) {
        _store = ObservedObject(wrappedValue: store)
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: .eight) {
            errorView
            contentView
            loadingView
            retryButton
        }
        .navigationTitle(ArtworkListKey.title.localized)
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: .sixteen) {
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
    
    @ViewBuilder
    private var errorView: some View {
        if let message = store.errorMessage {
            Rectangle()
                .frame(height: .fiftyTwo)
                .foregroundStyle(.red)
                .overlay {
                    Text(message)
                        .font(.body)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                }
        }
    }
    
    @ViewBuilder
    private var retryButton: some View {
        if store.errorMessage != nil {
            Button {
                store.reload()
            } label: {
                VStack(alignment: .center, spacing: .eight) {
                    Image(systemName: GenericIcon.retry)
                        .font(.title)
                        .foregroundStyle(Color.white)
                    
                    Text(GenericKey.retry.localized)
                        .font(.title)
                        .foregroundStyle(Color.white)
                }
            }
            .padding()
            .background(Color.red.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: .eight))
            .accessibilityIdentifier(ArtworkListViewIds.retryButton)
        }
    }
}

public enum ArtworkListViewIds {
    public static let retryButton = "retry_button"
}

public enum ArtworkListKey: String, LocalizationKey, CaseIterable {
    case title
}

#Preview {
    NavigationStack {
        ArtworkListView(store: ArtworkListViewStore(loader: ArtworkLoaderDummy()))
    }
}
