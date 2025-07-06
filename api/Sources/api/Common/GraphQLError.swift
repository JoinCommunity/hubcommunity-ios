import Foundation

public enum GraphQLError: LocalizedError, Sendable, Equatable {
    case noData
    case networkError(Error)

    public var errorDescription: String? {
        switch self {
        case .noData:
            "No data received from GraphQL query"
        case .networkError(let error):
            "Network error: \(error.localizedDescription)"
        }
    }

    public static func == (lhs: GraphQLError, rhs: GraphQLError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData): true
        case (.networkError, .networkError): true // Only compare type, not underlying error
        default: false
        }
    }
}
