//
//  SearchRecipesViewModel.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation
import Combine

class RecipesViewModel: ObservableObject {
    enum ViewState: Equatable {
        case error, normal, searching
    }
    
    @Published var recipes: [Recipe] = []
    @Published var savedRecipes: [Recipe] = []
    @Published var searchKeyword = ""
    @Published var viewState: ViewState = .normal
    @Published var currentPage = 1
    @Published var dietSelected: String = "none" {
        didSet {
            self.currentPage = 0
            self.recipes = []
            self.searchRecipes(with: searchKeyword)
        }
    }
    @Published var errorMessage = ""
    
    private let service: RecipeService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RecipeService) {
        self.service = service
        
        self.$searchKeyword
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] term in
                self?.currentPage = 1
                self?.recipes = []
                self?.searchRecipes(with: term)
            }
            .store(in: &subscriptions)
    }
    
    func loadMoreRecipes() {
        self.currentPage += 1
        self.searchRecipes(with: searchKeyword)
    }
    
    private func searchRecipes(with keyword: String) {
        guard self.viewState != .searching else { return }
        
        self.viewState = .searching
        
        self.service
            .search(by: keyword, filterByDiet: dietSelected, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { finished in
                switch finished {
                    case .finished: print("finished")
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
                self.recipes.append(contentsOf: response.results)
                self.viewState = .normal
            })
            .store(in: &subscriptions)
    }
    
    func shouldLoadData(currentItem: Recipe) -> Bool {
        let triggerIndex = recipes.index(recipes.endIndex, offsetBy: -5)
        let currentItemIndex = recipes.firstIndex(where: { $0.id == currentItem.id  })

        return currentItemIndex == triggerIndex
    }
}

// MARK: - Save Recipe logic
extension RecipesViewModel {
    func updateSavedRecipe(recipe: Recipe, saved: Bool) {
        if saved && savedRecipes.allSatisfy({ $0.id != recipe.id}) {
            self.savedRecipes.append(recipe)
        }
        
        if let index = savedRecipes.firstIndex(of: recipe), !saved {
            savedRecipes.remove(at: index)
        }
    }
    
    func add(recipes: [Recipe]) {
        self.savedRecipes = recipes
    }
    
    func isSaved(for id: Int) -> Bool {
        return savedRecipes.contains(where: { $0.id == id })
    }
}
