//
//  ContentView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var recipesViewModel = RecipesViewModel(service: SpoonacularAPI())
    @StateObject var cacheManager: CacheManager = CacheManager.shared
    
    var body: some View {
        ZStack {
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
            .opacity(!cacheManager.loadFromDiskComplete ? 0 : 1)
            
            if !cacheManager.loadFromDiskComplete {
                ProgressView()
            }
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active: 
                    cacheManager.loadFromDisk()
                case .inactive:
                    cacheManager.savedRecipes = recipesViewModel.savedRecipes
                    cacheManager.saveToDisk()
                case .background: 
                    cacheManager.savedRecipes = recipesViewModel.savedRecipes
                    cacheManager.saveToDisk()
                @unknown default: print("phase not yet used")
            }
        }
        .onReceive(cacheManager.$loadFromDiskComplete) { complete in
            guard complete && cacheManager.hasSavedRecipes() else { return }
            recipesViewModel.savedRecipes = cacheManager.savedRecipes
        }
    }
}

#Preview {
    ContentView()
}
