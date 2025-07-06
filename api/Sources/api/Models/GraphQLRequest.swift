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
