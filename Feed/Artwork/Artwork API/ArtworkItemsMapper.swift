//
//  ArtworkItemsMapper.swift
//  Artwork
//
//  Created by Rafael Rios on 28/12/25.
//

import Foundation

enum ArtworkItemsMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteArtworkLoader.Result {
        guard OK_Statuses.contains(response.statusCode) else {
            return .failure(RemoteArtworkLoader.Error.invalidData)
        }
        
        do {
            let items = try JSONDecoder().decode(Root.self, from: data)
            return .success(items.data.map(\.item))
        } catch {
            return .failure(RemoteArtworkLoader.Error.invalidData)
        }
    }
    
    private static let OK_Statuses = 200..<300
    
    private struct Root: Decodable {
        let data: [Item]
    }
    
    private struct Item: Decodable {
        let id: Int
        let title: String
        let dateDisplay: String?
        let description: String?
        let dimensionsDetails: [ItemDimensionsDetails]
        let placeOfOrigin: String?
        let artistID: Int?
        let artistTitle: String?
        let imageID: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case dateDisplay = "date_display"
            case description
            case dimensionsDetails = "dimensions_detail"
            case placeOfOrigin = "place_of_origin"
            case artistID = "artist_id"
            case artistTitle = "artist_title"
            case imageID = "image_id"
        }
        
        var item: ArtworkItem {
            ArtworkItem(id: id,
                     title: title,
                     dateDisplay: dateDisplay,
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
