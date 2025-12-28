//
//  FeedItemsMapper.swift
//  Feed
//
//  Created by Rafael Rios on 28/12/25.
//

import Foundation

enum FeedItemsMapper {
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard OK_Statuses.contains(response.statusCode) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let root = try decoder.decode(Root.self, from: data)
        return root.data.map { $0.item }
    }
    
    private static let OK_Statuses = 200..<300
    
    private struct Root: Decodable {
        let data: [Item]
    }
    
    private struct Item: Decodable {
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
        
        enum CodingKeys: String, CodingKey {
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

    private struct ItemDimensionsDetails: Decodable {
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
}
