//
//  FeedItem.swift
//  Feed
//
//  Created by Rafael Rios on 27/12/25.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: Int
    public let title: String
    public let dateStart: Date
    public let dateEnd: Date?
    public let description: String?
    public let dimensionsDetails: [DimensionsDetails]
    public let placeOfOrigin: String?
    public let artistID: Int?
    public let artistTitle: String?
    public let imageID: String?
    
    public init(
        id: Int,
        title: String,
        dateStart: Date,
        dateEnd: Date?,
        description: String?,
        dimensionsDetails: [DimensionsDetails],
        placeOfOrigin: String?,
        artistID: Int?,
        artistTitle: String?,
        imageID: String?
    ) {
        self.id = id
        self.title = title
        self.dateStart = dateStart
        self.dateEnd = dateEnd
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

struct Item: Decodable {
    let id: Int
    let title: String
    let dateStart: Date
    let dateEnd: Date?
    let description: String?
    let dimensionsDetails: [ItemDimensionsDetails]
    let placeOfOrigin: String?
    let artistID: Int?
    let artistTitle: String?
    let imageID: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case description
        case dimensionsDetails = "dimensions_details"
        case placeOfOrigin = "place_of_origin"
        case artistID = "artist_id"
        case artistTitle = "artist_title"
        case imageID = "image_id"
    }
    
    var item: FeedItem {
        FeedItem(id: id,
                 title: title,
                 dateStart: dateStart,
                 dateEnd: dateEnd,
                 description: description,
                 dimensionsDetails: dimensionsDetails.map { $0.item },
                 placeOfOrigin: placeOfOrigin,
                 artistID: artistID,
                 artistTitle: artistTitle,
                 imageID: imageID)
    }
}

struct ItemDimensionsDetails: Decodable {
    let depth: Double?
    let width: Double?
    let height: Double?
    let diameter: Double?
    
    var item: DimensionsDetails {
        DimensionsDetails(
            depth: depth,
            width: width,
            height: height,
            diameter: diameter
        )
    }
}
