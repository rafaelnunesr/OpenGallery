//
//  ImageView.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import SwiftUI

public struct ImageView: View {
    private let url: URL
    @State private var imageId = UUID()
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            AsyncImagePhaseView(phase: phase) {
                imageId = UUID()
            }
            .id(imageId)
        }
    }
}

#Preview {
    ImageView(url: URL(string: "https://any-url.com")!)
}
