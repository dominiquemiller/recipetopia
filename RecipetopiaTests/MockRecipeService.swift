//
//  MockRecipeService.swift
//  RecipetopiaTests
//
//  Created by Dominique Miller on 11/3/23.
//

import Foundation
import Combine
@testable import Recipetopia

class RecipeServiceMock: RecipeService {
    var returnError = false
    var searchResponse: SearchResults
    var fullRecipe: Recipe
    
    init(returnError: Bool) {
        let searchUrl = Bundle.main.url(forResource: "searchRecipes", withExtension: "json")!
        let searchJsonData = try! Data(contentsOf: searchUrl)
        
        let recipeUrl = Bundle.main.url(forResource: "recipe", withExtension: "json")!
        let recipeJsonData = try! Data(contentsOf: recipeUrl)
        
        let decoder = JSONDecoder()
        
        self.fullRecipe = try! decoder.decode(Recipe.self, from: recipeJsonData)
        self.searchResponse = try! decoder.decode(SearchResults.self, from: searchJsonData)
        
        self.returnError = returnError
    }
    
    func search(by keyword: String, filterByDiet: String?, page: Int) -> AnyPublisher<SearchResults, Error> {
        return Future<SearchResults, Error> { promise in
            if self.returnError {
                promise(.failure(APIError.unauthorized))
            } else {
                promise(.success(self.searchResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    func recipe(with id: Int) -> AnyPublisher<Recipe, Error> {
        return Future<Recipe, Error> { promise in
            if self.returnError {
                promise(.failure(APIError.badRequest))
            } else {
                promise(.success(self.fullRecipe))
            }
        }.eraseToAnyPublisher()
    }
}
