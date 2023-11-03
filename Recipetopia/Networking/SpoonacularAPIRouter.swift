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
        // Ideally we can place this in info.plist or download from backend.
        let apiKey = "6d8c11ea63054dd7be1c17fa59f77040"
        let recipesPerPage = 20
        switch self {
            case .seachRecipes(let query, let filterByDiet, let page):
                guard let filterByDiet else { return [ "query" : query, "apiKey" : apiKey, "number" : recipesPerPage, "offset" : (page * recipesPerPage) ] }
                return [ "query" : query, "diet" : filterByDiet ]
            case .recipe(_, let nutritionInformation): return [ "includeNutrition" : nutritionInformation, "apiKey" : apiKey ]
        }
    }
}
