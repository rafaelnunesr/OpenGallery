//
//  ArtworkListLocalizationTests.swift
//  Artwork
//
//  Created by Rafael Rios on 22/01/26.
//

import XCTest
import Artwork
import Foundation

final class ArtworkListLocalizationTests: XCTestCase {
    
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
        
        assertLocalizedKeysExist(ArtworkListKey.allCases.map(\.key), at: catalogURL)
    }
}
