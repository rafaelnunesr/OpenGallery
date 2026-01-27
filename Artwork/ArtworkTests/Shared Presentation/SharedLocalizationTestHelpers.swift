//
//  SharedLocalizationTestHelpers.swift
//  Artwork
//
//  Created by Rafael Rios on 17/01/26.
//

import XCTest

func assertLocalizedKeysExist(
    _ keys: [String],
    at url: URL,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    guard let data = try? Data(contentsOf: url),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let sourceLanguage = json["sourceLanguage"] as? String,
          let strings = json["strings"] as? [String: Any] else {
        XCTFail("❌ Could not parse String Catalog", file: file, line: line)
        return
    }

    for key in keys {
        guard let entry = strings[key] as? [String: Any] else {
            XCTFail("❌ Key '\(key)' is completely missing from the Catalog file.", file: file, line: line)
            continue
        }

        let localizations = entry["localizations"] as? [String: Any] ?? [:]
        
        let sourceResult = extractValueAndState(from: localizations[sourceLanguage] as? [String: Any])
        let sourceValue = sourceResult.value
        
        for language in SupportedLanguages.allCases {
            let isSourceLanguage = (language.rawValue == sourceLanguage)
            let localization = localizations[language.rawValue] as? [String: Any]
            let result = extractValueAndState(from: localization)

            if localization == nil {
                XCTFail("❌ Key '\(key)' is missing translation for '\(language.rawValue)'. (Language is 0% complete)", file: file, line: line)
                continue
            }

            if !isSourceLanguage && (result.state == "untranslated" || result.state == "needs_review") {
                XCTFail("❌ Key '\(key)' in (\(language.rawValue)) is marked as '\(result.state ?? "stale")' in Xcode.", file: file, line: line)
                continue
            }

            let exceptions = ["Artworks", "Retry"]
            if !isSourceLanguage && !exceptions.contains(key) && result.value == sourceValue {
                XCTFail("""
                ❌ Placeholder found for '\(key)' in (\(language.rawValue))! 
                Current Value: "\(result.value)" matches English.
                """, file: file, line: line)
            }
        }
    }
}

// MARK: - Helpers

private func extractValueAndState(from localization: [String: Any]?) -> (value: String, state: String?) {
    guard let localization = localization else { return ("", nil) }
    
    if let variations = localization["variations"] as? [String: Any],
       let idioms = variations["idiom"] as? [String: Any],
       let firstIdiom = idioms.values.first as? [String: Any],
       let stringUnit = firstIdiom["stringUnit"] as? [String: Any] {
        return (stringUnit["value"] as? String ?? "", stringUnit["state"] as? String)
    }
    
    if let stringUnit = localization["stringUnit"] as? [String: Any] {
        return (stringUnit["value"] as? String ?? "", stringUnit["state"] as? String)
    }
    
    return ("", nil)
}

extension URL {
    func backTo(folderName: String) -> URL? {
        var current = self
        while current.path != "/" {
            if current.lastPathComponent == folderName { return current }
            current = current.deletingLastPathComponent()
        }
        return nil
    }
}

private enum SupportedLanguages: String, CaseIterable {
    case english = "en"
    case brazilianPortuguese = "pt-BR"
}
