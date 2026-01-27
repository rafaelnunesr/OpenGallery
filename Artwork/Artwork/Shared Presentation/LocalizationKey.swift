//
//  LocalizationKey.swift
//  Artwork
//
//  Created by Rafael Rios on 17/01/26.
//

import Foundation

public protocol LocalizationKey: RawRepresentable where RawValue == String {}

public extension LocalizationKey {
    func string(
        bundle: Bundle = .main,
        table: String? = nil
    ) -> String {
        bundle.localizedString(
            forKey: rawValue,
            value: nil,
            table: table
        )
    }
}

public extension LocalizationKey {
    var localized: String {
        self.string()
    }
}
