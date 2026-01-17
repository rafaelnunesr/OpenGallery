//
//  LoadResourcePresenterTests.swift
//  Artwork
//
//  Created by Rafael Rios on 14/01/26.
//

import Testing
import Artwork
import Combine

struct LoadResourcePresenterTests {
    
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
    
    @Test
    func didFinishLoadingResource_displaysResourceAndStopsLoading() {
        let (sut, viewState) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        
        sut.didFinishLoading(with: "resource")
        
        #expect(viewState.messages == [.resource("resource view model"), .loading(false), .error(nil)])
    }
    
    @Test
    func didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, viewState) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        #expect(viewState.messages == [.error(ErrorKey.genericError.string()), .loading(false)])
    }
    
    @Test
    func didFinishLoadingWithMapperError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, viewState) = makeSUT(mapper: { resource in
            throw anyNSError()
        })
        
        sut.didFinishLoading(with: anyNSError())
        
        #expect(viewState.messages == [.error(ErrorKey.genericError.string()), .loading(false)])
    }
    
    // MARK: - Helpers
    
    private typealias SUT = LoadResourcePresenter<String, ViewStateSpy>
    
    private func makeSUT(mapper: @escaping SUT.Mapper  = { _ in "any" }) -> (sut: SUT, viewState: ViewStateSpy) {
        let viewState = ViewStateSpy()
        
        let sut = LoadResourcePresenter(
            resourceViewState: viewState,
            loadingViewState: viewState,
            errorViewState: viewState,
            mapper: mapper
        )
        
        return (sut: sut, viewState: viewState)
    }
    
    private class ViewStateSpy: ResourceViewState, LoadingViewState, ErrorViewState {
        @Published var value: String = "" {
            didSet {
                messages.insert(.resource(value))
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
            case resource(String)
            case loading(Bool)
            case error(String?)
        }
        
        private(set) var messages = Set<Message>()
        
        init() {}
    }
}
