//
//  APIError.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import Foundation

enum APIError: Error {
    case badRequest
    case unauthorized
    case internalServerError
    case noServerResponse
    case notFound
    case unknown
}
