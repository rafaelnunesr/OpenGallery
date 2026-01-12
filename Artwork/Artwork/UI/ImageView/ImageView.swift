//
//  ImageView.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import SwiftUI

public struct ImageView: View {
    private let url: URL
    @State private var imageState = ImageState.loading
    
    enum ImageState {
        case loading
    }
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) { _ in
        } placeholder: {
            placeholder
        }
    }
    
    private var placeholder: some View {
        switch imageState {
        case .loading:
            ProgressView()
        }
    }
    
}

#Preview {
    ImageView(url: URL(string: "https://any-url.com")!)
}
