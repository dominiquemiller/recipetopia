//
//  RecipetopiaApp.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

@main
struct RecipetopiaApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var cacheManager: CacheManager = CacheManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cacheManager)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active: cacheManager.loadFromDisk()
                case .inactive: cacheManager.saveToDisk()
                case .background: cacheManager.saveToDisk()
                @unknown default: print("phase not yet used")
            }
        }
    }
}
