//
//  RecipetopiaTests.swift
//  RecipetopiaTests
//
//  Created by Dominique Miller on 11/2/23.
//

import XCTest
import Combine
@testable import Recipetopia

final class RecipesViewModelTests: XCTestCase {
    private var disposables = Set<AnyCancellable>()

    func testOnInit_hasRecipes() throws {
        let mockService = RecipeServiceMock(returnError: false)
        let viewModel = RecipesViewModel(service: mockService)
        
        let validExpectation = self.expectation(description: "Recipes have been loaded!")
        
        viewModel.$recipes
            .drop(while: { $0.count == 0} )
            .sink { _ in
                validExpectation.fulfill()
            }.store(in: &disposables)
        
        wait(for: [validExpectation], timeout: 1)
        XCTAssert(viewModel.recipes.count == 2, "Recipes were not loaded.")
    }
    
    func testSavingRecipe() throws {
        let mockService = RecipeServiceMock(returnError: false)
        let viewModel = RecipesViewModel(service: mockService)
        
        let validExpectation = self.expectation(description: "Recipes have been loaded!")
        
        viewModel.$recipes
            .drop(while: { $0.count == 0} )
            .sink { _ in
                validExpectation.fulfill()
            }.store(in: &disposables)
        
        wait(for: [validExpectation], timeout: 1)
        
        viewModel.updateSavedRecipe(recipe: viewModel.recipes[0], saved: true)
        
        XCTAssert(viewModel.savedRecipes.count == 1, "Recipe was not saved.")
    }
    
    func testNetworkError_displaysUserMessage() {
        let mockService = RecipeServiceMock(returnError: true)
        let viewModel = RecipesViewModel(service: mockService)
        
        let validExpectation = self.expectation(description: "View state has changed!")
        
        viewModel.$viewState
            .sink { state in
                guard state == .error else { return }
                validExpectation.fulfill()
            }.store(in: &disposables)
        
        wait(for: [validExpectation], timeout: 2)
        XCTAssert(viewModel.errorMessage == "You are unauthorized to download recipes. Please check your API key.", "View stae was not changed")
    }
}
