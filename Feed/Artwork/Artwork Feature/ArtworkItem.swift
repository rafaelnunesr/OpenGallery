//
//  ArtworkItem.swift
//  Artwork
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation

public struct ArtworkItem: Equatable {
    public let id: Int
    public let title: String
    public let dateDisplay: String?
    public let description: String?
    public let dimensionsDetails: [DimensionsDetails]
    public let placeOfOrigin: String?
    public let artistID: Int?
    public let artistTitle: String?
    public let imageID: String?
    
    public init(
        id: Int,
        title: String,
        dateDisplay: String?,
        description: String?,
        dimensionsDetails: [DimensionsDetails],
        placeOfOrigin: String?,
        artistID: Int?,
        artistTitle: String?,
        imageID: String?
    ) {
        self.id = id
        self.title = title
        self.dateDisplay = dateDisplay
        self.description = description
        self.dimensionsDetails = dimensionsDetails
        self.placeOfOrigin = placeOfOrigin
        self.artistID = artistID
        self.artistTitle = artistTitle
        self.imageID = imageID
    }
}

public struct DimensionsDetails: Equatable {
    public let depth: Double?
    public let width: Double?
    public let height: Double?
    public let diameter: Double?
    
    public init(
        depth: Double?,
        width: Double?,
        height: Double?,
        diameter: Double?
    ) {
        self.depth = depth
        self.width = width
        self.height = height
        self.diameter = diameter
    }
}
