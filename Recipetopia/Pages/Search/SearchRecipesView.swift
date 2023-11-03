//
//  SearchRecipesView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct SearchRecipesView: View {
    @EnvironmentObject var viewModel: RecipesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: self.$viewModel.dietSelected, label: Text("Diet:")) {
                    Text("Vegetarian").tag("vegetarian")
                    Text("Vegan").tag("vegan")
                    Text("Paleo").tag("paleo")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button(action: { viewModel.dietSelected = "none" }, label: { Text("Clear") })
            }
            .padding(.horizontal)
            
            List(viewModel.recipes) { recipe in
                NavigationLink {
                    RecipeDetailView(viewModel: RecipeDetailViewModel(id: recipe.id, service: SpoonacularAPI())) { self.viewModel.updateSavedRecipe(recipe: $0, saved: $1)}
                } label: {
                    CardView(recipe: recipe)
                        .onAppear {
                            if viewModel.shouldLoadData(currentItem: recipe) {
                                viewModel.loadMoreRecipes()
                            }
                        }
                }
                
                if viewModel.viewState == .searching {
                    ProgressView()
                }
            }
            .searchable(text: $viewModel.searchKeyword, prompt: "Find something yummy!")
            .navigationTitle("Search Recipes")
        }
    }
}

#Preview {
    SearchRecipesView()
        .environmentObject(RecipesViewModel(service: SpoonacularAPI()))
}
