//
//  SavedRecipesView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/3/23.
//

import SwiftUI

struct SavedRecipesView: View {
    @EnvironmentObject var viewModel: RecipesViewModel
    
    var body: some View {
        ZStack {
            List(viewModel.savedRecipes) { recipe in
                NavigationLink {
                    RecipeDetailView(viewModel: RecipeDetailViewModel(id: recipe.id, service: SpoonacularAPI()))
                } label: {
                    VStack(alignment: .leading) {
                        AsyncImage(url: recipe.image) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(recipe.title)
                            .font(.headline)
                    }
                    .cornerRadius(4)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
            }
            .navigationTitle("Saved Recipes")
            
            if viewModel.savedRecipes.count == 0 {
                ContentUnavailableView("Oh Oh! Looks like you haven't saved any recipes yet!",
                                       systemImage: "hand.raised.slash")
            }
        }
    }
}

#Preview {
    SavedRecipesView()
        .environmentObject(RecipesViewModel(service: SpoonacularAPI()))
}
