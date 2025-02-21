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
                .task {
                    await loadRecipes()
                }
                .refreshable {
                    await loadRecipes()
                }
            }
            .navigationTitle("Recipes")
            
//            .onTapGesture {
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//            }
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
