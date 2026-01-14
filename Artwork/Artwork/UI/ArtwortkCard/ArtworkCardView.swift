//
//  ArtworkCardView.swift
//  Artwork
//
//  Created by Rafael Rios on 05/01/26.
//

import SwiftUI

public struct ArtworkCardViewModel: Identifiable, Equatable, Hashable {
    public let id: String
    let title: String
    let date: String
    let description: String
    let dimensions: String
    let placeOfOrigin: String
    let artist: String
    let imageURL: URL
    
    var detailsView: String {
        placeOfOrigin + " - " + date + " - " + dimensions
    }
    
    var artistInfo: String {
        "by " + artist
    }
    
    public init(id: String,
                title: String,
                date: String,
                description: String,
                dimensions: String,
                placeOfOrigin: String,
                artist: String,
                imageURL: URL) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.dimensions = dimensions
        self.placeOfOrigin = placeOfOrigin
        self.artist = artist
        self.imageURL = imageURL
    }
}

public struct ArtworkCardView: View {
    private let model: ArtworkCardViewModel
    
    public init(model: ArtworkCardViewModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageView
            titleLabel
            artistLabel
            detailsView
            descriptionLabel
        }
        .padding()
    }
    
    private var imageView: some View {
        ImageView(url: model.imageURL)
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 400)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var titleLabel: some View {
        Text(model.title)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.leading)
    }
    
    private var artistLabel: some View {
        Text(model.artist)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    private var descriptionLabel: some View {
        Text(model.description)
            .font(.body)
            .multilineTextAlignment(.leading)
    }
    
    private var detailsView: some View {
        Text(model.detailsView)
        .font(.footnote)
        .foregroundStyle(.secondary)
        .padding(.bottom, 4)
    }
}

#Preview {
    let model = ArtworkCardViewModel(
        id: "id",
        title: "A title",
        date: "400 BCE",
        description: "Some description",
        dimensions: "some dimension",
        placeOfOrigin: "some place",
        artist: "An artist",
        imageURL: URL(string: "https://any-url.com")!
    )
    ArtworkCardView(model: model)
}
