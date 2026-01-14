//
//  ArtworkPresenterTests.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Testing
import SwiftUI
import Artwork
import Combine

protocol ArtworkListViewState: ObservableObject {
    var list: [ArtworkCardViewModel] { get set }
}

protocol LoadingViewState: ObservableObject {
    var isLoading: Bool { get set }
}

protocol ErrorViewState: ObservableObject {
    var errorMessage: String? { get set }
}

class ArtworkPresenter {
    private let resourceViewState: any ArtworkListViewState
    private let loadingViewState: any LoadingViewState
    private let errorViewState: any ErrorViewState
    
    init(
        resourceViewState: any ArtworkListViewState,
        loadingViewState: any LoadingViewState,
        errorViewState: any ErrorViewState,
    ) {
        self.resourceViewState = resourceViewState
        self.loadingViewState = loadingViewState
        self.errorViewState = errorViewState
    }
    
    func didStartLoading() {
        loadingViewState.isLoading = true
        errorViewState.errorMessage = nil
    }
}

struct ArtworkPresenterTests {
    
    @Test
    func init_doesNotSendMessagesToView() {
        let viewState = makeSUT().viewState
        
        #expect(viewState.messages.isEmpty)
    }
    
    @Test
    func didStartLoading_displaysNoErrorMessageAndStartsLoading() {
        let (sut, viewState) = makeSUT()
        
        sut.didStartLoading()
        
        #expect(viewState.messages == [.loading(true), .error(nil)])
    }
    
    // MARK: - Helpers
    
    private typealias SUT = (sut: ArtworkPresenter, viewState: ViewStateSpy)
    
    private func makeSUT() -> SUT {
        let viewState = ViewStateSpy()
        
        let sut = ArtworkPresenter(
            resourceViewState: viewState,
            loadingViewState: viewState,
            errorViewState: viewState
        )
        
        return (sut, viewState)
    }
    
    private class ViewStateSpy: ArtworkListViewState, LoadingViewState, ErrorViewState {
        @Published var list = [ArtworkCardViewModel]() {
            didSet {
                messages.insert(.list(list))
            }
        }
        
        @Published var isLoading: Bool = false {
            didSet {
                messages.insert(.loading(isLoading))
            }
        }
        
        @Published var errorMessage: String? = nil {
            didSet {
                messages.insert(.error(errorMessage))
            }
        }
        
        enum Message: Hashable {
            case list([ArtworkCardViewModel])
            case loading(Bool)
            case error(String?)
        }
        
        private(set) var messages = Set<Message>()
        
        init() {}
    }
}
