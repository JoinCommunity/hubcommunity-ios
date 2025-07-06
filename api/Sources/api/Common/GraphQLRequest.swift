import Foundation

struct GraphQLRequest: Codable {
    let query: String
}

struct GraphQLResponse<T: Codable>: Codable {
    let data: T?
    let errors: [GraphQLErrorResponse]?
}

struct GraphQLErrorResponse: Codable {
    let message: String
}
