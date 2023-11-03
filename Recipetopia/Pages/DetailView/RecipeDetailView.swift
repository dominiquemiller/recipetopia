//
//  RecipeDetailView.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeDetailViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RecipeDetailView(viewModel: RecipeDetailViewModel(id: 0))
}
