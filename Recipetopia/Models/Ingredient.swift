//
//  Ingredient.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

struct Ingredient: Codable, Identifiable {
    let id: Int
    let name: String
    // Amount and name
    let original: String
}
