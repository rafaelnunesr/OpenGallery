//
//  AsyncImagePhaseViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import XCTest
import Artwork
import SwiftUI

final class AsyncImagePhaseViewTests: XCTestCase {
    func test_layout_loading() {
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeLoadingPhase())
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_LOADING_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_LOADING_LAYOUT_DARK")
    }
    
    func test_layout_retry() {
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeRetryPhase())
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_RETRY_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_RETRY_LAYOUT_DARK")
    }
    
    func test_layout_success() {
        let sut = AsyncImagePhaseView(phase: AsyncImagePhase.makeSuccessPhase())
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_SUCCESS_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_SUCCESS_LAYOUT_DARK")
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
