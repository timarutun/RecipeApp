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
                HStack {
                    AsyncImage(url: recipe.photoURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
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
