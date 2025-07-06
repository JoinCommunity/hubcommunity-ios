import Foundation
import models

// MARK: - Service Protocol
public protocol EventsServiceProtocol: Sendable {
    func getEvents() async throws -> [Event]
}

// MARK: - Events Service Implementation
public class EventsService: EventsServiceProtocol, @unchecked Sendable {
    private let graphQLClient: GraphQLClientProtocol
    
    public init(graphQLClient: GraphQLClientProtocol = GraphQLClient()) {
        self.graphQLClient = graphQLClient
    }
    
    public func getEvents() async throws -> [Event] {
        return try await graphQLClient.fetchEvents()
    }
}

// MARK: - Service Factory
public class EventsServiceFactory {
    public static func createService(
        baseURL: URL = URL(string: "https://hubcommunity-bff.8020digital.com.br/graphql")!
    ) -> EventsServiceProtocol {
        let client = GraphQLClient(url: baseURL)
        return EventsService(graphQLClient: client)
    }
    
    public static func createMockService(
        mockEvents: [Event] = [],
        shouldThrowError: Bool = false,
        mockError: Error = GraphQLError.noData
    ) -> EventsServiceProtocol {
        let mockClient = MockGraphQLClient(
            mockEvents: mockEvents,
            shouldThrowError: shouldThrowError,
            mockError: mockError
        )
        return EventsService(graphQLClient: mockClient)
    }
} 