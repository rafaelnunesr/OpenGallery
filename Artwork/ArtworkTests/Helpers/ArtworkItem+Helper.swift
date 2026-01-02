//
//  ArtworkItem+Helper.swift
//  Artwork
//
//  Created by Rafael Rios on 28/12/25.
//

import Artwork
import Foundation

extension ArtworkItem {
    static func makeItem(
        id: Int = 1,
        title: String = "Some title",
        dateDisplay: String? = "410 - 400 BCE",
        description: String = "some description",
        placeOfOrigin: String = "some place",
        artistID: Int = 1,
        artistTitle: String = "some artist",
        imageID: String = "some id",
        dimensionsDetails: [DimensionsDetails] = []
    ) -> (item: ArtworkItem, json: [String: Any?]) {
        let item = ArtworkItem(
            id: id,
            title: title,
            dateDisplay: dateDisplay,
            description: description,
            dimensionsDetails: dimensionsDetails,
            placeOfOrigin: placeOfOrigin,
            artistID: artistID,
            artistTitle: artistTitle,
            imageID: imageID
        )
        
        
        let dimensionsDetailsJSON: [[String: Any?]] = dimensionsDetails.map {
            [
                "depth": $0.depth,
                "width": $0.width,
                "height": $0.height,
                "diameter": $0.diameter
            ]
        }
        
        let itemJSON: [String : Any?] = [
            "id": id,
            "title": title,
            "date_display": dateDisplay,
            "description": description,
            "dimensions_detail": dimensionsDetailsJSON,
            "place_of_origin": placeOfOrigin,
            "artist_id": artistID,
            "artist_title": artistTitle,
            "image_id": imageID
        ]
        
        return (item, itemJSON)
    }
    
    static func makeItem1() -> (item: ArtworkItem, json: [String: Any?]) {
        makeItem(
            id: 1,
            title: "Some title",
            dateDisplay: "410 - 400 BCE",
            description: "some description",
            placeOfOrigin: "some place",
            artistID: 1,
            artistTitle: "some artist",
            imageID: "some id",
            dimensionsDetails: [DimensionsDetails(depth: 1, width: 1, height: 1, diameter: 1)]
        )
    }
    
    static func makeItem2() -> (item: ArtworkItem, json: [String: Any?]) {
        makeItem(
            id: 1,
            title: "Some title",
            dateDisplay: "300 - 280 BCE",
            description: "some description",
            placeOfOrigin: "some place",
            artistID: 1,
            artistTitle: "some artist",
            imageID: "some id",
            dimensionsDetails: [DimensionsDetails(depth: 1, width: 1, height: 1, diameter: 1)]
        )
    }
    
    static func makeItemsJSON() -> (items: [ArtworkItem], json: [String: Any?]) {
        let (item1, item1JSON) = makeItem1()
        let (item2, item2JSON) = makeItem2()
        
        let json = ["data": [item1JSON, item2JSON]]
        
        return ([item1, item2], json)
    }
    
    static func makeEmptyJSON() -> [String: Any?] {
        ["data": []]
    }
}
