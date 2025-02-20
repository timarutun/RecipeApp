//
//  Recipe.swift
//  RecipeApp
//
//  Created by Timur on 2/18/25.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    static func mockRecipe() -> Recipe {
            return Recipe(
                id: UUID(),
                name: "Bakewell Tart",
                cuisine: "British",
                photoURLSmall: URL(string: "https://example.com/small1.jpg"),
                photoURLLarge: URL(string: "https://example.com/large1.jpg"),
                sourceURL: URL(string: "https://example.com/source1"),
                youtubeURL: URL(string: "https://www.youtube.com/watch?v=abc123")
            )
        }
}

