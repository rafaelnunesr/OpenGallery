//
//  ArtworkListViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import XCTest
import Artwork

final class ArtworkListViewTests: XCTestCase {
    func test_layout() {
        let sut = makeSUT()
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ArtworkListView<ArtworkListViewModelStub> {
        let data = ArtworkListViewData(list: [ArtworkCardViewModel.model1, ArtworkCardViewModel.model2])
        let viewModel = ArtworkListViewModelStub(data: data)
        return ArtworkListView(viewModel: viewModel)
    }
    
    private class ArtworkListViewModelStub: ArtworkListViewModelProtocol {
        var data: ArtworkListViewData
        
        init(data: ArtworkListViewData) {
            self.data = data
        }
    }
}
