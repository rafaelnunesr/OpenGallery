//
//  ArtworkPresenterTests.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Testing
import SwiftUI
import Artwork
internal import Combine

protocol ResourceView: ObservableObject {
    associatedtype ViewState
    var state: ViewState { get }
}

struct ArtworkListViewState {
    let list: [ArtworkCardViewModel]
}

class ArtworkPresenter {
    private let resourceView: any ResourceView
    
    init(resourceView: any ResourceView) {
        self.resourceView = resourceView
    }
}

struct ArtworkPresenterTests {
    
    @Test
    func init_doesNotSendMessagesToView() {
        let resourceView = ResourceViewSpy()
        _ = ArtworkPresenter(resourceView: resourceView)
        
        #expect(resourceView.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private class ResourceViewSpy: ResourceView {
        @Published var state: ArtworkListViewState
        var messages = [ArtworkListViewState]()
        
        init(state: ArtworkListViewState = .init(list: [])) {
            self.state = state
        }
    }
}
