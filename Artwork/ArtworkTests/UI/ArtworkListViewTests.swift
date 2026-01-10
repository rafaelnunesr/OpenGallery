//
//  ArtworkListViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import XCTest
import Artwork
import SwiftUI

final class ArtworkListViewTests: XCTestCase {
    func test_layout() {
        let sut = makeSUT()
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ArtworkListView<ArtworkListViewModelStub> {
        let imageResult = ImageResult.failure
        let data = ArtworkListViewData(list: [(makeModel1(), imageResult) , (makeModel2(), imageResult)])
        let viewModel = ArtworkListViewModelStub(data: data)
        return ArtworkListView(viewModel: viewModel)
    }
    
    private class ArtworkListViewModelStub: ArtworkListViewModelProtocol {
        var data: ArtworkListViewData
        
        init(data: ArtworkListViewData) {
            self.data = data
        }
    }
    
    private func makeModel1() -> ArtworkCardViewModel {
        ArtworkCardViewModel(
            id: "id_1",
            title: "A title",
            date: "400 BCE",
            description: "Some description",
            dimensions: "some dimension",
            placeOfOrigin: "some place",
            artist: "An artist"
        )
    }
    
    private func makeModel2() -> ArtworkCardViewModel {
        ArtworkCardViewModel(
            id: "id_2",
            title: "Another title",
            date: "300 BCE",
            description: "Another description",
            dimensions: "another dimension",
            placeOfOrigin: "another place",
            artist: "Another artist"
        )
    }
}
