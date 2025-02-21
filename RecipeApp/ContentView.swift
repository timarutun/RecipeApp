//
//  ContentView.swift
//  RecipeApp
//
//  Created by Timur on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []

    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    HStack(alignment: .top) {
                        CachedAsyncImage(url: recipe.photoURLSmall)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await loadRecipes()
            }
            .refreshable {
                await loadRecipes()
            }
        }
    }
    
    func loadRecipes() async {
        do {
            let fetchedRecipes = try await RecipeAPIClient().fetchRecipes()
            recipes = fetchedRecipes
        } catch {
            print("Failed to load recipes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
