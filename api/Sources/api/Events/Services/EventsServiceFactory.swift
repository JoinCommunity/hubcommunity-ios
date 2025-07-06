import Foundation

public class EventsServiceFactory {
    public static func createService(
        baseURL: URL = URL(string: "https://hubcommunity-bff.8020digital.com.br/graphql")!
    ) -> EventsServiceProtocol {
        let client = GraphQLClient(url: baseURL)
        return EventsService(graphQLClient: client)
    }

    public static func createMockService(
        mockEvents: [EventDto] = [],
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

    public static func createServiceWithCustomClient(
        graphQLClient: GraphQLClientProtocol
    ) -> EventsServiceProtocol {
        EventsService(graphQLClient: graphQLClient)
    }
}

// MARK: - Generic Service Factory

public class GenericServiceFactory {
    public static func createGenericService(
        baseURL: URL = URL(string: "https://hubcommunity-bff.8020digital.com.br/graphql")!
    ) -> GenericGraphQLServiceProtocol {
        let client = GraphQLClient(url: baseURL)
        return GenericGraphQLService(graphQLClient: client)
    }

    public static func createMockGenericService(
        mockEvents: [EventDto] = [],
        shouldThrowError: Bool = false,
        mockError: Error = GraphQLError.noData
    ) -> GenericGraphQLServiceProtocol {
        let mockClient = MockGraphQLClient(
            mockEvents: mockEvents,
            shouldThrowError: shouldThrowError,
            mockError: mockError
        )
        return GenericGraphQLService(graphQLClient: mockClient)
    }

    public static func createGenericServiceWithCustomClient(
        graphQLClient: GraphQLClientProtocol
    ) -> GenericGraphQLServiceProtocol {
        GenericGraphQLService(graphQLClient: graphQLClient)
    }
}
