//
//  RecipeAPIClient.swift
//  RecipeApp
//
//  Created by Timur on 2/18/25.
//

import Foundation

struct RecipeAPIClient {
    
    var recipesURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    //MARK: Fetching Recipes
    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: recipesURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else {
                throw URLError(.badServerResponse)
            }
        
        let decodedData = try JSONDecoder().decode([String: [Recipe]].self, from: data)
        
        guard let recipes = decodedData["recipes"] else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return recipes
    }
}
