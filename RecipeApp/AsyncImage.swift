//
//  AsyncImage.swift
//  RecipeApp
//
//  Created by Timur on 2/19/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    
    var body: some View {
        if let url = url {
            if let cachedImage = ImageCache.shared.cachedImage(for: url) {
                Image(uiImage: cachedImage)
                    .resizable()
                    .scaledToFill()
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                        .onAppear {
                            if let uiImage = image.asUIImage() {
                                ImageCache.shared.cacheImage(uiImage, for: url)
                            }
                        }
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFill()
        }
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let renderer = UIGraphicsImageRenderer(size: view?.bounds.size ?? .zero)
        return renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
    }
}
