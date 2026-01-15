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
    func test_layout_idle() {
        let store = ArtworkListViewStoreStub(value: [ArtworkCardViewModel.model1, ArtworkCardViewModel.model2])
        let sut = ArtworkListView(store: store)
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_IDLE_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_IDLE_DARK")
    }
    
    func test_layout_loading() {
        let store = ArtworkListViewStoreStub(value: [ArtworkCardViewModel.model1, ArtworkCardViewModel.model2], isLoading: true)
        let sut = ArtworkListView(store: store)
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_LOADING_DARK")
    }
    
    func test_layout_error() {
        let store = ArtworkListViewStoreStub(value: [ArtworkCardViewModel.model1, ArtworkCardViewModel.model2], errorMessage: "GENERIC ERROR MESSAGE")
        let sut = ArtworkListView(store: store)
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_ERROR_DARK")
    }
    
    // MARK: - Helpers
    
    private class ArtworkListViewStoreStub: ArtworkListViewStoreProtocol {
        @Published var value = [ArtworkCardViewModel]()
        @Published var isLoading = false
        @Published var errorMessage: String? = nil
        
        init(value: [ArtworkCardViewModel] = [], isLoading: Bool = false, errorMessage: String? = nil) {
            self.value = value
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }
}
