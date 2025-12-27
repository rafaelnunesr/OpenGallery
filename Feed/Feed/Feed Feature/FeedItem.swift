//
//  FeedItem.swift
//  Feed
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation

public struct FeedItem: Equatable {
    let id: Int
    let title: String
    let dateStart: Date
    let dateEnd: Date?
    let description: String?
    let dimensionsDetails: [DimensionsDetails]
    let placeOfOrigin: String?
    let artistID: Int?
    let artistTitle: String?
    let imageID: String?
}

public struct DimensionsDetails: Equatable {
    let depth: Double?
    let width: Double?
    let height: Double?
    let diameter: Double?
}
