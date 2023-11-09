//
//  CacheManager.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/3/23.
//

import Foundation

class CacheManager: ObservableObject {
    @Published var loadFromDiskComplete = false
    
    private let fileName = "savedRecipes.json"
    var savedRecipes: [Recipe] = []
    
    static let shared = CacheManager()
    
    func updateSavedRecipes(for recipe: Recipe, saved: Bool) {
        if saved && savedRecipes.allSatisfy({ $0.id != recipe.id}) {
            savedRecipes.append(recipe)
        } else {
            if let index = savedRecipes.firstIndex(of: recipe) {
                savedRecipes.remove(at: index)
            }
        }
    }
    
    func loadFromDisk() {
        self.loadFromDiskComplete = false
        
        defer { self.loadFromDiskComplete = true }
        
        // Find the cached file, should only be one
        guard let folderURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
        let directoryContents = try? FileManager.default.contentsOfDirectory(at: folderURLs, includingPropertiesForKeys: nil),
        let cachedFile = directoryContents.filter({ $0.pathExtension == "json" }).first else { return }
        
        // Begin decoding
        guard let jsonData = try? Data(contentsOf: cachedFile) else { return }
        
        let decoder = JSONDecoder()
        do {
            self.savedRecipes = try decoder.decode([Recipe].self, from: jsonData)
        } catch {
            // Error decoding, file is corrupt
            // Destroy file
            try? FileManager.default.removeItem(at: cachedFile)
        }
    }
    
    func saveToDisk() {
        let folderURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(self.fileName)
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self.savedRecipes) else { return }
        try? data.write(to: fileURL)
    }
    
    func hasSavedRecipes() -> Bool {
        return savedRecipes.count > 0
    }
}
