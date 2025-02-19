//
//  RecipeAPIClientTests.swift
//  RecipeAppTests
//
//  Created by Timur on 2/19/25.
//

import XCTest
@testable import RecipeApp

final class RecipeAPIClientTests: XCTestCase {

    func testFetchRecipes() async throws {
        
        let apiClient = RecipeAPIClient()
        
        do {
            let recipes = try await apiClient.fetchRecipes()
            
            XCTAssertFalse(recipes.isEmpty, "Recipes array is empty")
            
            if let firstRecipe = recipes.first {
                XCTAssertNotNil(firstRecipe.id, "Recipe id is nill")
                XCTAssertFalse(firstRecipe.name.isEmpty, "Recipe name is empty")
            }
        } catch {
            XCTFail("Error fetching recepies. Error: \(error)")
        }
    }

}
