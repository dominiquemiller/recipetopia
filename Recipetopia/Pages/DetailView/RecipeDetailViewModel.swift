//
//  RecipeDetailViewModel.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation
import Combine

class RecipeDetailViewModel: ObservableObject {
    enum ViewState: Equatable {
        case error, normal, loading
    }
    
    @Published var recipe: Recipe? = nil
    @Published var viewState: ViewState = .normal
    @Published var errorMessage = ""
    
    private let recipeId: Int
    private let service: RecipeService
    private var subscriptions = Set<AnyCancellable>()
    
    init(id: Int, service: RecipeService) {
        self.recipeId = id
        self.service = service
        
        self.loadRecipe()
    }
    
    private func loadRecipe() {
        self.viewState = .loading
        
        self.service.recipe(with: recipeId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { finished in
                switch finished {
                    case .finished: self.viewState = .normal
                    case .failure(let error):
                        guard let apiError = error as? APIError else {
                            return }
                        self.viewState = .error
                        // TODO: - additional messages for other errors
                        if apiError == .unauthorized {
                            self.errorMessage = "You are unauthorized to download recipes. Please check your API key."
                        }
                }
            }, receiveValue: { response in
                self.recipe = response
            })
            .store(in: &subscriptions)
    }
    
    func nutrient(for name: String, showUnit: Bool = true) -> String {
        guard let nutrients = recipe?.nutrition?.nutrients,
              let nutrient = nutrients.first(where: {$0.name == name }) else { return "" }
        
        return "\(nutrient.name): \(Int(nutrient.amount))\(showUnit ? nutrient.unit : "")"
        
    }
    
    
}
