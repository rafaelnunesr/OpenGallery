//
//  LoadResourcePresenterLocalizationTests.swift
//  Artwork
//
//  Created by Rafael Rios on 27/01/26.
//

import XCTest
import Artwork

final class LoadResourcePresenterLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let testFileURL = URL(fileURLWithPath: #filePath)
        guard let projectRoot = testFileURL.backTo(folderName: "Artwork") else {
            XCTFail("Could not find project root folder 'Artwork'")
            return
        }

        let catalogURL = projectRoot
            .appendingPathComponent("Artwork")
            .appendingPathComponent("Shared Presentation")
            .appendingPathComponent("Localizable.xcstrings")
        
        assertLocalizedKeysExist(ErrorKey.allCases.map(\.rawValue), at: catalogURL)
    }
}
