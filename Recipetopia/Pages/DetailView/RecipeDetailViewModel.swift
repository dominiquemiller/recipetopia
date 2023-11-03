//
//  RecipeDetailViewModel.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

class RecipeDetailViewModel: ObservableObject {
    private let recipeId: Int
    
    init(id: Int) {
        self.recipeId = id
    }
}
