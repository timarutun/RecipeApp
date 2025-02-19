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
    let photoURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURL = "photo_url_small"
    }
}
