//
//  ContentView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                SearchRecipesView(viewModel: SearchRecipesViewModel(service: SpoonacularAPI()))
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("find recipes")
            }
            
            Text("Saved Recipes")
                .tabItem {
                    Image(systemName: "fork.knife.circle")
                    Text("SavedRecipes")
                }
        }
        .tint(.green)
    }
}

#Preview {
    ContentView()
}
