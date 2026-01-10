//
//  ArtworkCardViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 05/01/26.
//

import XCTest
import Artwork
import SwiftUI

final class ArtworkCardViewTests: XCTestCase {
    func test_layout() {
        let sut = ArtworkCardView(model: makeModel(), image: makeImageView())
        assert(snapshot: sut.snapshot(for: .light()), named: "IDLE_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "IDLE_LAYOUT_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeModel() -> ArtworkCardViewModel {
        ArtworkCardViewModel(
            id: "id",
            title: "A title",
            date: "400 BCE",
            description: "Some description",
            dimensions: "some dimension",
            placeOfOrigin: "some place",
            artist: "An artist"
        )
    }
    
    private func makeImageView() -> some View {
        Color.red.opacity(0.1)
    }
}
