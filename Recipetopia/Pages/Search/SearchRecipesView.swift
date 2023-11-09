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
            ZStack {
                List(viewModel.recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(viewModel: RecipeDetailViewModel(id: recipe.id, service: SpoonacularAPI()),
                                         isSaved: viewModel.isSaved(for: recipe.id)) { self.viewModel.updateSavedRecipe(recipe: $0, saved: $1)}
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
                .alert(viewModel.errorMessage, isPresented: .constant(self.viewModel.viewState == .error)) {
                    Button("OK", role: .cancel) { }
                }
                
                if viewModel.viewState == .searching && viewModel.recipes.count == 0 {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    let viewModel = RecipesViewModel(service: SpoonacularAPI())
    return PreviewDataWrapper(filename: "searchRecipes", model: SearchResults.self) { searchResults in
        viewModel.recipes = searchResults.results
        return SearchRecipesView()
            .environmentObject(viewModel)
    }
}
