//
//  RecipeDetailView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeDetailViewModel
    @State var isSaved: Bool = false
    var buttonAction: ((_ recipe: Recipe, _ saved: Bool) -> Void)?
    var body: some View {
        ZStack {
            if let recipe = viewModel.recipe {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                isSaved.toggle()
                                CacheManager.shared.updateSavedRecipes(for: recipe, saved: isSaved)
                                buttonAction?(recipe, isSaved)
                            } label: {
                                Image(systemName: recipe.saved ? "heart.fill" : "heart")
                                    .imageScale(.large)
                                    .foregroundColor(Color.pink)
                            }
                            .symbolEffect(.bounce, value: isSaved)
                        }
                        AsyncImage(url: recipe.image) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .clipShape(Circle())
                        .frame(maxHeight: 200)
                        .shadow(radius: 10, x: 1, y: 1)
                        
                        Text(recipe.title)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            if let servings = recipe.servings {
                                HStack {
                                    Image(systemName: "fork.knife")
                                    Text("servings: \(servings)")
                                }
                            }
                            
                            Spacer()
                            
                            if let totalTime = recipe.readyInMinutes {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("Total Time: \(totalTime) min")
                                }
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Nutrition Information:")
                                .font(.headline)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(viewModel.nutrient(for: "Calories", showUnit: false))
                                    Text(viewModel.nutrient(for: "Carbohydrates"))
                                    Text(viewModel.nutrient(for: "Protein"))
                                    Text(viewModel.nutrient(for: "Fat"))
                                }
                                Spacer()
                            }
                        }
                        
                        Divider()
                        
                        if let ingredients = recipe.extendedIngredients {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("What you will need:")
                                        .font(.headline)
                                    ForEach(ingredients, id:\.id) { ingredient in
                                        Text(ingredient.original)
                                            .font(.subheadline)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        if let instructions = recipe.instructions, !instructions.isEmpty {
                            Divider()
                            
                            VStack(alignment: .leading) {
                                Text("Instructions:")
                                    .font(.title)
                                // TODO: - Some instructions have html embedded, so better to use the "analyzedInstructions" array to itemize the ingredients for a better UI.
                                Text(instructions)
                            }
                            
                            Divider()
                        }
                        
                    }
                    .padding()
                }
            }
            
            if viewModel.viewState == .loading {
                ProgressView()
            }
        }
    }
}

#Preview {
    RecipeDetailView(viewModel: RecipeDetailViewModel(id: 782585, service: SpoonacularAPI()))
}
