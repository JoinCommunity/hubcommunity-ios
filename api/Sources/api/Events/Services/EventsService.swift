import Foundation
import models

public protocol EventsServiceProtocol: Sendable {
    func getEvents() async throws -> [Event]
}

public class EventsService: EventsServiceProtocol, @unchecked Sendable {
    private let graphQLClient: GraphQLClientProtocol

    public init(graphQLClient: GraphQLClientProtocol = GraphQLClient()) {
        self.graphQLClient = graphQLClient
    }

    public func getEvents() async throws -> [Event] {
        try await graphQLClient.fetchEvents()
    }
}
