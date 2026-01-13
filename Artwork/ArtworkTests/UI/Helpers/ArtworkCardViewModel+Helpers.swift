//
//  ArtworkCardViewModel+Helpers.swift
//  Artwork
//
//  Created by Rafael Rios on 10/01/26.
//

import Artwork

extension ArtworkCardViewModel {
    static let model1 = ArtworkCardViewModel(
        id: "id_1",
        title: "A title",
        date: "400 BCE",
        description: "Some description",
        dimensions: "some dimension",
        placeOfOrigin: "some place",
        artist: "An artist",
        imageURL: anyURL()
    )
    
    static let model2 = ArtworkCardViewModel(
        id: "id_2",
        title: "Another title",
        date: "300 BCE",
        description: "Another description",
        dimensions: "another dimension",
        placeOfOrigin: "another place",
        artist: "Another artist",
        imageURL: anyURL()
    )
}
