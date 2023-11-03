//
//  CardView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/3/23.
//

import SwiftUI

struct CardView: View {
    var recipe: Recipe
    
    var body: some View {
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

#Preview {
    PreviewDataWrapper(filename: "recipe", model: Recipe.self) { recipe in
        CardView(recipe: recipe)
    }
}
