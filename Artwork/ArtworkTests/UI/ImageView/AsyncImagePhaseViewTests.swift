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
        let sut = AsyncImagePhaseView(phase: .empty)
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_LOADING_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_LOADING_LAYOUT_DARK")
    }
    
    func test_layout_retry() {
        let sut = AsyncImagePhaseView(phase: .failure(anyNSError()))
        
        assert(snapshot: sut.snapshot(for: .light()), named: "ASYNC_IMAGE_PHASE_VIEW_RETRY_LAYOUT_LIGHT")
        assert(snapshot: sut.snapshot(for: .dark()), named: "ASYNC_IMAGE_PHASE_VIEW_RETRY_LAYOUT_DARK")
    }
}
