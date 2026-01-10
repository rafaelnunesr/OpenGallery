//
//  ArtworkCardViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 05/01/26.
//

import XCTest
import Artwork

final class ArtworkCardViewTests: XCTestCase {
    func test_layout() {
        let sut = ArtworkCardView(model: ArtworkCardViewModel.model1, image: makeRedView())
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_CARD_VIEW_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_CARD_VIEW_LAYOUT_DARK")
    }
}
