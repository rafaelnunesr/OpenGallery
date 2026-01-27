//
//  ArtworkListViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import Combine
import XCTest
import Artwork
import ViewInspector

final class ArtworkListViewTests: XCTestCase {
    func test_layout_idle() {
        let sut = makeSUT().sut
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_IDLE_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_IDLE_DARK")
    }
    
    func test_layout_loading() {
        let sut = makeSUT(isLoading: true).sut
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_LOADING_DARK")
    }
    
    func test_layout_error() {
        let sut = makeSUT(hasError: true).sut
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ARTWORK_LIST_VIEW_LAYOUT_ERROR_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ARTWORK_LIST_VIEW_LAYOUT_ERROR_DARK")
    }
    
    func test_when_retryButtonIsTapped_reloadShouldBeTriggered() throws {
        let (sut, store) = makeSUT(hasError: true)
        
        let retryButton = try sut.inspect().find(ViewType.Button.self, where: {
            try $0.accessibilityIdentifier() == ArtworkListViewIds.retryButton
        })
        
        try retryButton.tap()
        
        XCTAssertEqual(store.messages, [.reload])
    }
    
    // MARK: - Helpers
    private typealias SUT = (sut: ArtworkListView<ArtworkListViewStoreStub>, store: ArtworkListViewStoreStub)
    
    private func makeSUT(isLoading: Bool = false, hasError: Bool = false) -> SUT {
        let store = ArtworkListViewStoreStub(
            value: [ArtworkCardViewModel.model1, ArtworkCardViewModel.model2],
            isLoading: isLoading,
            errorMessage: hasError ? GenericKey.errorMessage.localized : nil
        )
        
        let sut = ArtworkListView(store: store)
        
        return (sut, store)
    }
    
    private class ArtworkListViewStoreStub: ArtworkListViewStoreProtocol {
        @Published var value = [ArtworkCardViewModel]()
        @Published var isLoading = false
        @Published var errorMessage: String? = nil
        
        private(set) var messages: [Message] = []
        
        enum Message {
            case reload
        }
        
        init(value: [ArtworkCardViewModel] = [], isLoading: Bool = false, errorMessage: String? = nil) {
            self.value = value
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
        
        func reload() {
            messages.append(.reload)
        }
    }
}
