//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Timur on 2/20/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(url: recipe.photoURLLarge)
                    .frame(height: 300)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                

                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 16) {
                    if let sourceURL = recipe.sourceURL {
                        Button(action: {
                            openURL(sourceURL)
                        }) {
                            HStack {
                                Image(systemName: "safari")
                                Text("Website")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }
                    
                    if let youtubeURL = recipe.youtubeURL {
                        Button(action: {
                            openURL(youtubeURL)
                        }) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                Text("Video")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe.mockRecipe())
}
