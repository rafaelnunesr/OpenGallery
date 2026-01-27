//
//  AsyncImagePhaseView.swift
//  Artwork
//
//  Created by Rafael Rios on 13/01/26.
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
        case let .success(image):
            image
                .resizable()
                .scaledToFit()
        case .failure:
            retryView
        default:
            progressView
        }
    }
    
    private var retryView: some View {
        Button {
            retryAction()
        } label: {
            ZStack {
                Color.lightRed
                
                VStack(alignment: .center, spacing: .eight) {
                    Image(systemName: GenericIcon.retry)
                        .font(.title)
                        .foregroundStyle(Color.white)
                    
                    Text(GenericKey.retry.localized)
                        .font(.title)
                        .foregroundStyle(Color.white)
                }
            }
        }
        .accessibilityIdentifier(AccessibilityIds.button)
    }
    
    private var progressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    public enum AccessibilityIds {
        public static let button = "retry_button"
    }
}
