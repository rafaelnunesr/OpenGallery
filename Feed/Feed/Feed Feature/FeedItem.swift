//
//  FeedItem.swift
//  Feed
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation

struct FeedItem {
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

struct DimensionsDetails {
    let depth: Double?
    let width: Double?
    let height: Double?
    let diameter: Double?
}
