//
//  SearchRecipesViewModel.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation
import Combine

class SearchRecipesViewModel: ObservableObject {
    enum ViewState: Equatable {
        case error, normal, searching
    }
    @Published var recipes: [Recipe] = []
    @Published var searchKeyword = ""
    @Published var viewState: ViewState = .normal
    @Published var currentPage = 0
    
    private let service: RecipeService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RecipeService) {
        self.service = service
        
        self.$searchKeyword
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] term in
                print("######################################")
                print(term)
                print("######################################")
                self?.searchRecipes(with: term)
            }
            .store(in: &subscriptions)
    }
    
    func loadMoreRecipes() {
        self.currentPage += 1
        self.searchRecipes(with: searchKeyword)
    }
    
    private func searchRecipes(with keyword: String) {
        self.viewState = .searching
        
        self.service
            .search(by: keyword, filterByDiet: nil, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] finished in
                switch finished {
                    case .finished: print("All done.")
                    case .failure(_):  self?.viewState = .error
                }
            }, receiveValue: { [weak self]  response in
                self?.recipes = response.results
                self?.viewState = .normal
            })
            .store(in: &subscriptions)
    }
    
    func shouldLoadData(for index: Int) -> Bool {
        print("############################ index + 1: \(index + 1), index count: \(recipes.count - 5)")
        return (index + 1) == recipes.count - 5
    }
}
