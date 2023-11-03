//
//  SearchRecipesView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct SearchRecipesView: View {
    @StateObject var viewModel: SearchRecipesViewModel
    var body: some View {
        List(viewModel.recipes) { recipe in
            NavigationLink {
                Text("Damn! I'm here")
            } label: {
                VStack {
                    Text(recipe.title)
                    AsyncImage(url: recipe.image)
                }
            }
            .onAppear {
                print("onAppear for recipe: \(recipe.title), \(recipe.id)")
                if viewModel.shouldLoadData(for: recipe.id) {
                    
                }
            }
        }
        .searchable(text: $viewModel.searchKeyword, prompt: "Find something yummy!")
    }
}

#Preview {
    SearchRecipesView(viewModel: SearchRecipesViewModel(service: SpoonacularAPI()))
}
