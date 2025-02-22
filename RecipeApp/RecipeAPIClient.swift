//
//  RecipeAPIClient.swift
//  RecipeApp
//
//  Created by Timur on 2/18/25.
//

import Foundation

struct RecipeAPIClient {
    var recipesURL: URL
    private let session: URLSession
    
    init(recipesURL: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
         session: URLSession = .shared) {
        self.recipesURL = recipesURL
        self.session = session
    }
    
    //MARK: Fetching Recipes
    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await session.data(from: recipesURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RecipeError.badServerResponse
        }
        
        let decodedData: [String: [Recipe]]
        do {
            decodedData = try JSONDecoder().decode([String: [Recipe]].self, from: data)
        } catch {
            throw RecipeError.decodingError(error)
        }
        
        guard let recipes = decodedData["recipes"] else {
            throw RecipeError.emptyData
        }
        
        return recipes
    }
}

enum RecipeError: Error, LocalizedError {
    case badServerResponse
    case decodingError(Error)
    case emptyData
    case malformedData

    var errorDescription: String? {
        switch self {
        case .badServerResponse:
            return "We couldn't connect to the server. Please check your internet connection and try again."
        case .decodingError:
            return "There was a problem loading the recipes. Please try again later."
        case .emptyData:
            return "No recipes found. Please try refreshing the list."
        case .malformedData:
            return "The recipe data is corrupted. Please try again later."
        }
    }
}
