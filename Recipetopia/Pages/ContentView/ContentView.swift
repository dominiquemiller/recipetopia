//
//  ContentView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var recipesViewModel = RecipesViewModel(service: SpoonacularAPI())
    @EnvironmentObject var cacheManager: CacheManager
    var body: some View {
        TabView {
            NavigationStack {
                SearchRecipesView()
                    .environmentObject(recipesViewModel)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("find recipes")
            }
            
            NavigationStack {
               SavedRecipesView()
                    .environmentObject(recipesViewModel)
            }
            .tabItem {
                Image(systemName: "fork.knife.circle")
                Text("SavedRecipes")
            }
        }
        .tint(.green)
        .onChange(of: cacheManager.loadFromDiskComplete) { complete in
            if complete {
                self.recipesViewModel.add(recipes: cacheManager.savedRecipes)
            }
        }
    }
}

#Preview {
    ContentView()
}
