//
//  SharedLocalizationTestHelpers.swift
//  Artwork
//
//  Created by Rafael Rios on 17/01/26.
//

import XCTest

func assertLocalizedKeysExist(
    _ keyProviders: [() -> [String]],
    in bundle: Bundle,
    table: String? = nil,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let localizations = bundle.localizations

    localizations.forEach { localization in
        guard
            let path = bundle.path(forResource: localization, ofType: "lproj"),
            let localizedBundle = Bundle(path: path)
        else {
            XCTFail("Couldn't find bundle for localization: \(localization)", file: file, line: line)
            return
        }

        keyProviders.forEach { provideKeys in
            provideKeys().forEach { key in
                let localizedString = localizedBundle.localizedString(
                    forKey: key,
                    value: nil,
                    table: table
                )

                if localizedString == key {
                    let language = Locale.current.localizedString(forLanguageCode: localization) ?? localization

                    XCTFail(
                        "Missing \(language) (\(localization)) localized string for key '\(key)'"
                        + (table != nil ? " in table '\(table!)'" : ""),
                        file: file,
                        line: line
                    )
                }
            }
        }
    }
}
