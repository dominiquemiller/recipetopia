//
//  SpoonacularAPIRouter.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

enum SpoonacularAPIRouter {
    typealias requestQueryParams = [String : Any]
    
    case seachRecipes(query: String, filterByDiet: String?, page: Int),
         recipe(id: Int, nutritionInformation: Bool)
    
    var path: String {
        switch self {
            case .seachRecipes: "/recipes/complexSearch"
            case .recipe(let id, _): "/recipes/\(id)/information"
        }
    }
    
    var queryParams: requestQueryParams? {
        // Never do this in production! Opted for simplicity for the time limit we have.
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "SpoonAPIKey") as? String ?? ""
        let recipesPerPage = 20
        
        switch self {
            case .seachRecipes(let query, let filterByDiet, let page):
                let offSet = page == 0 ? recipesPerPage : page * recipesPerPage
                guard let filterByDiet = filterByDiet else {
                    return [ "query" : query, "apiKey" : apiKey, "number" : recipesPerPage, "offset" : offSet ]
                }
                return [ "query" : query, "diet" : filterByDiet, "apiKey" : apiKey, "number" : recipesPerPage, "offset" : offSet ]
            case .recipe(_, let nutritionInformation): return [ "includeNutrition" : nutritionInformation, "apiKey" : apiKey ]
        }
    }
}
