//
//  Recipe.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

struct Nutrient: Codable {
    let name: String
    let amount: Double
    let unit: String
    let percentOfDailyNeeds: Double
}

struct Nutrition: Codable {
    let nutrients: [Nutrient]
}

struct Recipe: Codable, Identifiable, Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let title: String
    let image: URL?
    let servings: Int?
    let readyInMinutes: Int?
    let extendedIngredients: [Ingredient]?
    let nutrition: Nutrition?
    let instructions: String?
    let vegan: Bool?
    let vegetarian: Bool?
    let veryHealthy: Bool?
    var saved: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        // MARK: - Optionals
        
        let imageUrlString = try container.decode(String.self, forKey: .image)
        self.image = URL(string: imageUrlString)
        
        self.servings = try container.decodeIfPresent(Int.self, forKey: .servings)
        self.readyInMinutes = try container.decodeIfPresent(Int.self, forKey: .readyInMinutes)
        self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        self.vegan = try container.decodeIfPresent(Bool.self, forKey: .vegan)
        self.vegetarian = try container.decodeIfPresent(Bool.self, forKey: .vegetarian)
        self.veryHealthy = try container.decodeIfPresent(Bool.self, forKey: .veryHealthy)
        self.extendedIngredients = try container.decodeIfPresent([Ingredient].self, forKey: .extendedIngredients)
        self.nutrition = try container.decodeIfPresent(Nutrition.self, forKey: .nutrition)
    }
}
