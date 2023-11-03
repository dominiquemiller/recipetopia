//
//  Recipe.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: Int
    let title: String
    let image: URL?
    let servings: Int?
    let readyInMinutes: Int?
    let extendedIngredients: [Ingredient]?
    let summary: String?
    let vegan: Bool?
    let vegetarian: Bool?
    let veryHealthy: Bool?
    let veryPopular: Bool?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        // MARK: - Optionals
        
        let imageUrlString = try container.decode(String.self, forKey: .image)
        self.image = URL(string: imageUrlString)
        
        self.servings = try container.decodeIfPresent(Int.self, forKey: .servings)
        self.readyInMinutes = try container.decodeIfPresent(Int.self, forKey: .readyInMinutes)
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
        self.vegan = try container.decodeIfPresent(Bool.self, forKey: .vegan)
        self.vegetarian = try container.decodeIfPresent(Bool.self, forKey: .vegetarian)
        self.veryHealthy = try container.decodeIfPresent(Bool.self, forKey: .veryHealthy)
        self.veryPopular = try container.decodeIfPresent(Bool.self, forKey: .veryPopular)
        self.extendedIngredients = try container.decodeIfPresent([Ingredient].self, forKey: .extendedIngredients)
    }
}
