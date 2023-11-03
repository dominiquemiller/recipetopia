//
//  SavedRecipeManager.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

class SavedRecipeManager: ObservableObject {
    @Published var savedRecipes: [Recipe] = []
    
    // TODO: - ADD / REMOVE RECPES
    // TODO: - SAVE RECIPES TO DISK (JSON)
    // TODO: - DECODE RECIPES FROM DISK (JSON)
}
