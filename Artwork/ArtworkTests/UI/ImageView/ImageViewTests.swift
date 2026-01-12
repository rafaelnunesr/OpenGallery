//
//  ImageViewTests.swift
//  Artwork
//
//  Created by Rafael Rios on 12/01/26.
//

import XCTest
import Artwork

final class ImageViewTests: XCTestCase {
    func test_layout_loading() {
        URLProtocolStub.startInterceptingRequests()
        
        let sut = makeSUT(isLoading: true)
        
        record(snapshot: sut.snapshot(for: .light()), named: "IMAGE_VIEW_LOADING_LAYOUT_LIGHT")
        record(snapshot: sut.snapshot(for: .dark()), named: "IMAGE_VIEW_LOADING_LAYOUT_DARK")
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        isLoading: Bool = true,
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) -> ImageView {
        URLProtocolStub.stub(data: anyData(), response: anyHTTPURLResponse())
        
        let url = anyURL()
        return ImageView(url: url)
    }
}
