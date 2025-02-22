//
//  ContentView.swift
//  RecipeApp
//
//  Created by Timur on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    @State private var searchText: String = ""
    @State private var selectedCuisine: String? = nil
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var cuisineTypes: [String] {
        let cuisines = Set(recipes.map { $0.cuisine })
        return ["All"] + cuisines.sorted()
    }
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText)
            let matchesCuisine = selectedCuisine == nil || selectedCuisine == "All" || recipe.cuisine == selectedCuisine
            return matchesSearch && matchesCuisine
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Filter button
                    Menu {
                        ForEach(cuisineTypes, id: \.self) { cuisine in
                            Button(action: { selectedCuisine = (cuisine == "All" ? nil : cuisine) }) {
                                Text(cuisine)
                                if selectedCuisine == cuisine || (selectedCuisine == nil && cuisine == "All") {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    // Search bar
                    TextField("Search recipes", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                // Recipes list
                if filteredRecipes.isEmpty {
                    // Empty state
                    VStack {
                        Spacer()
                        Text("No recipes found")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List(filteredRecipes) { recipe in
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
                }
            }
            .navigationTitle("Recipes")
            .task {
                await loadRecipes()
            }
            .refreshable {
                await loadRecipes()
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func loadRecipes() async {
        do {
            let fetchedRecipes = try await RecipeAPIClient().fetchRecipes()
            recipes = fetchedRecipes
        } catch {
            if let recipeError = error as? RecipeError {
                errorMessage = recipeError.errorDescription ?? "An unknown error occurred."
            } else {
                errorMessage = "An unexpected error occurred. Please try again later."
            }
            showErrorAlert = true
        }
    }
}

#Preview {
    ContentView()
}
