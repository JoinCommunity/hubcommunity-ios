import Foundation
import models

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
