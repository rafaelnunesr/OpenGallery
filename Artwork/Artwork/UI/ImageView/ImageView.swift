//
//  ImageView.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import SwiftUI

public struct AsyncImagePhaseView: View {
    private let phase: AsyncImagePhase
    private let retryAction: () -> Void
    
    public init(phase: AsyncImagePhase, retryAction: @escaping () -> Void) {
        self.phase = phase
        self.retryAction = retryAction
    }
    
    public var body: some View {
        switch phase {
        case .empty:
            ProgressView()
        case let .success(image):
            image
                .resizable()
                .scaledToFit()
        case .failure:
            retryView
        @unknown default:
            ProgressView()
        }
    }
    
    private var retryView: some View {
        Button {
            retryAction()
        } label: {
            ZStack {
                Color.red.opacity(0.3)
                
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .font(.title)
                        .foregroundStyle(Color.white)
                    
                    Text("Retry")
                        .font(.title)
                        .foregroundStyle(Color.white)
                }
            }
        }
        .accessibilityIdentifier(AccessibilityIds.button)
    }
    
    public enum AccessibilityIds {
        public static let button = "retry_button"
    }
}

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
