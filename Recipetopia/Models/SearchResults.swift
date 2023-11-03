//
//  SearchResults.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

struct SearchResults: Codable {
    let offset: Int
    let number: Int
    let results: [Recipe]
    let totalResults: Int
}
