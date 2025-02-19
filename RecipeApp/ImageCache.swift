//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Timur on 2/19/25.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // Create a dedicated directory for cached images
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        createCacheDirectory()
    }
    
    // Create the cache directory if it doesn't exist
    private func createCacheDirectory() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create cache directory: \(error.localizedDescription)")
            }
        }
    }
    
    // Save image to the cache
    func cacheImage(_ image: UIImage, for url: URL) {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let data = image.pngData() {
            do {
                try data.write(to: filePath)
            } catch {
                print("Failed to cache image: \(error.localizedDescription)")
            }
        }
    }
    
    // Retrieve image from the cache
    func cachedImage(for url: URL) -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: filePath.path) {
            return UIImage(contentsOfFile: filePath.path)
        }
        return nil
    }
    
    // Clear the cache for testing
    func clearCache() {
        do {
            try fileManager.removeItem(at: cacheDirectory)
            createCacheDirectory()
        } catch {
            print("Failed to clear cache: \(error.localizedDescription)")
        }
    }
}
