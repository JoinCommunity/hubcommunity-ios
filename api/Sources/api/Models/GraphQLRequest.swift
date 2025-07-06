//
//  GraphQLRequest.swift
//  api
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

// MARK: - GraphQL Request Models
struct GraphQLRequest: Codable {
    let query: String
}

struct GraphQLResponse: Codable {
    let data: EventsQueryData?
    let errors: [GraphQLErrorResponse]?
}

struct GraphQLErrorResponse: Codable {
    let message: String
} 