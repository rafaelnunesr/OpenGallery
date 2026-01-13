//
//  AsyncImagePhaseViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import XCTest
import Artwork
import SwiftUI
import ViewInspector

final class AsyncImagePhaseViewTests: XCTestCase {
    func test_layout_loading() {
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeLoadingPhase(), retryAction: {})
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_LOADING_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_LOADING_LAYOUT_DARK")
    }
    
    func test_layout_retry() {
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeRetryPhase(), retryAction: {})
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_RETRY_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_RETRY_LAYOUT_DARK")
    }
    
    func test_layout_success() {
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeSuccessPhase(), retryAction: {})
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_SUCCESS_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_SUCCESS_LAYOUT_DARK")
    }
    
    func test_retryButtonTap_triggersRetryAction() throws {
        var retryCount = 0
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeRetryPhase()) {
            retryCount += 1
        }
        
        let button = try sut.inspect().find(ViewType.Button.self, where: {
            try $0.accessibilityIdentifier() == AsyncImagePhaseView.AccessibilityIds.button
        })
        
        try button.tap()
        
        XCTAssertEqual(retryCount, 1)
    }
}

private extension AsyncImagePhase {
    static func makeLoadingPhase() -> Self {
        .empty
    }
    
    static func makeRetryPhase() -> Self {
        .failure(anyNSError())
    }
    
    static func makeSuccessPhase() -> Self {
        let image = Image(systemName: "xmark.triangle.circle.square.fill")
        return .success(image)
    }
}
