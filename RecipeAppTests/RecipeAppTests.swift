//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Timur on 2/18/25.
//

import XCTest
@testable import RecipeApp

final class RecipeAppTests: XCTestCase {
    
    //MARK: Test Fetching Recipes

    func testFetchRecipes() async throws {
        
        let apiClient = RecipeAPIClient()
        
        do {
            let recipes = try await apiClient.fetchRecipes()
            
            XCTAssertFalse(recipes.isEmpty, "Recipes array should not be empty")
            
            if let firstRecipe = recipes.first {
                XCTAssertNotNil(firstRecipe.id, "Recipe id should not be nill")
                XCTAssertFalse(firstRecipe.name.isEmpty, "Recipe name should not be empty")
            }
        } catch {
            XCTFail("Error fetching recepies. Error: \(error)")
        }
    }
    
    //MARK: Test Image Caching
    
    func testImageCaching() {
            let cache = ImageCache.shared
            let testImage = UIImage(systemName: "photo")!
            let testURL = URL(string: "https://example.com/testImage.png")!
            
            cache.cacheImage(testImage, for: testURL)
            let cachedImage = cache.cachedImage(for: testURL)
            
            XCTAssertNotNil(cachedImage, "Image should be cached")
    }
    
    //MARK: Test malformed data:
    
    func testFetchRecipesMalformedData() async {
        let malformedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        let apiClient = RecipeAPIClient(recipesURL: malformedURL)
            
        do {
            let recipes = try await apiClient.fetchRecipes()
            XCTFail("Expected to throw an error for malformed data, but succeeded with \(recipes.count) recipes.")
        } catch {
            XCTAssertTrue(error is RecipeError, "Expected RecipeError for malformed data.")
        }
    }
    
    //MARK: Test empty data
    
    func testFetchRecipesEmptyData() async {
        var apiClient = RecipeAPIClient()
        apiClient.recipesURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        
        do {
            let recipes = try await apiClient.fetchRecipes()
            XCTAssertTrue(recipes.isEmpty, "Expected empty array for empty data.")
        } catch {
            XCTFail("Expected to succeed with empty array, but got error: \(error)")
        }
    }
    
    
    
    

}
