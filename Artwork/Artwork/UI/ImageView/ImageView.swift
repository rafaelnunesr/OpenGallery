//
//  ImageView.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import SwiftUI

public struct ImageView: View {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) { _ in
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    ImageView(url: URL(string: "https://any-url.com")!)
}
