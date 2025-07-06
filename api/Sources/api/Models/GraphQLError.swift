//
//  GraphQLError.swift
//  api
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

// MARK: - Custom Errors
public enum GraphQLError: LocalizedError, Sendable, Equatable {
    case noData
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .noData:
            return "No data received from GraphQL query"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
    
    public static func == (lhs: GraphQLError, rhs: GraphQLError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData): return true
        case (.networkError, .networkError): return true // Only compare type, not underlying error
        default: return false
        }
    }
} 