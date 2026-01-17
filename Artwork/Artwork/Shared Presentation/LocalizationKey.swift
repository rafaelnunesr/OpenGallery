//
//  LocalizationKey.swift
//  Artwork
//
//  Created by Rafael Rios on 17/01/26.
//

import Foundation

public protocol LocalizationKey: RawRepresentable where RawValue == String {}

public enum ErrorKey: String, LocalizationKey {
    case genericError
}

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
