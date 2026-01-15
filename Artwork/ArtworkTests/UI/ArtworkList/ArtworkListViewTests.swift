//
//  ArtworkListViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import Combine
import XCTest
import Artwork

final class ArtworkListViewTests: XCTestCase {
    func test_layout() {
        let sut = makeSUT()
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ArtworkListView<ArtworkListViewStoreStub> {
        let store = ArtworkListViewStoreStub(value: [ArtworkCardViewModel.model1, ArtworkCardViewModel.model2])
        return ArtworkListView(store: store)
    }
    
    private class ArtworkListViewStoreStub: ArtworkListViewStoreProtocol {
        @Published var value = [ArtworkCardViewModel]()
        @Published var isLoading = false
        @Published var errorMessage: String? = nil
        
        init(value: [ArtworkCardViewModel]) {
            self.value = value
        }
    }
}
