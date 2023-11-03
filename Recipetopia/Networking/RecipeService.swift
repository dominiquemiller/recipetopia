//
//  RecipeService.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation
import Combine

protocol RecipeService {
    func search(by keyword: String, filterByDiet: String?, page: Int) -> AnyPublisher<SearchResults, Error>
    func recipe(with id: Int) -> AnyPublisher<Recipe, Error>
}

class SpoonacularAPI: RecipeService {
    private let apiBaseUrl = "https://api.spoonacular.com"
    
    func search(by keyword: String, filterByDiet: String?, page: Int = 0) -> AnyPublisher<SearchResults, Error> {
        let route = SpoonacularAPIRouter.seachRecipes(query: keyword, filterByDiet: filterByDiet, page: page)
        
        guard let request = buildRequest(for: route) else {
            return Fail(error: APIError.badRequest).eraseToAnyPublisher()
        }
        
        
        return performDataTask(for: request)
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func recipe(with id: Int) -> AnyPublisher<Recipe, Error> {
        let route = SpoonacularAPIRouter.recipe(id: id, nutritionInformation: true)
        
        guard let request = buildRequest(for: route) else {
            return Fail(error: APIError.badRequest).eraseToAnyPublisher()
        }
        
        return performDataTask(for: request)
            .decode(type: Recipe.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func performDataTask(for request: URLRequest) -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.noServerResponse
                }
                
                if httpResponse.statusCode != 200 {
                    throw self.statusCodeToApiError(for: httpResponse.statusCode)
                }
                
                return data
            }
    }
    
    
    private func statusCodeToApiError(for statusCode: Int) -> Error {
        switch statusCode {
            case 400:
                return APIError.badRequest
            case 401:
                return APIError.unauthorized
            case 404:
                return APIError.notFound
            case 500:
                return APIError.internalServerError
            default:
                return APIError.unknown
        }
    }
    
    private func encode(queryParams: [String : Any]) -> [URLQueryItem] {
        // Convert parameters to query items.
        return queryParams.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }
    
    private func buildRequest(for route: SpoonacularAPIRouter) -> URLRequest? {
        guard var urlComponents = URLComponents(string: apiBaseUrl) else {
            return nil
        }
        
        // Add the request path to the existing base URL path
        urlComponents.path = urlComponents.path + route.path
        
        // Add query items to the request URL
        if let params = route.queryParams {
            urlComponents.queryItems = encode(queryParams: params)
        }
        
        guard var url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}
