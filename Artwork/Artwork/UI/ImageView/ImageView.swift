//
//  ImageView.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import SwiftUI

public struct AsyncImagePhaseView: View {
    private let phase: AsyncImagePhase
    
    public init(phase: AsyncImagePhase) {
        self.phase = phase
    }
    
    public var body: some View {
        switch phase {
        case .empty:
            ProgressView()
        case .success:
            EmptyView()
        case .failure:
            EmptyView()
        @unknown default:
            ProgressView()
        }
    }
}

public struct ImageView: View {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            AsyncImagePhaseView(phase: phase)
        }
    }
}

#Preview {
    ImageView(url: URL(string: "https://any-url.com")!)
}
