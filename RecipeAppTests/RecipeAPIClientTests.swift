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
            
            XCTAssertFalse(recipes.isEmpty, "Recipes array should not be empty")
            
            if let firstRecipe = recipes.first {
                XCTAssertNotNil(firstRecipe.id, "Recipe id should not be nill")
                XCTAssertFalse(firstRecipe.name.isEmpty, "Recipe name should not be empty")
            }
        } catch {
            XCTFail("Error fetching recepies. Error: \(error)")
        }
    }
    
    func testImageCaching() {
            let cache = ImageCache.shared
            let testImage = UIImage(systemName: "photo")!
            let testURL = URL(string: "https://example.com/testImage.png")!
            
            cache.cacheImage(testImage, for: testURL)
            let cachedImage = cache.cachedImage(for: testURL)
            
            XCTAssertNotNil(cachedImage, "Image should be cached")
    }

}
