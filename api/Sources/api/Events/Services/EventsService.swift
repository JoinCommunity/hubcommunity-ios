import Foundation

public protocol EventsServiceProtocol: Sendable {
    func getEvents() async throws -> [EventDto]
}

public class EventsService: EventsServiceProtocol, @unchecked Sendable {
    private let graphQLClient: GraphQLClientProtocol

    public init(graphQLClient: GraphQLClientProtocol = GraphQLClient()) {
        self.graphQLClient = graphQLClient
    }

    public func getEvents() async throws -> [EventDto] {
        let query = """
        query Events {
          events {
            data {
              id
              title
              tags {
                value
                id
              }
              talks {
                id
                title
              }
              location {
                id
                title
              }
              images
              communities {
                id
                title
                members_quantity
              }
            }
          }
        }
        """
        let response: EventsQueryDto = try await graphQLClient.execute(
            query: query,
            responseType: EventsQueryDto.self
        )
        guard let eventsDto = response.events?.data else {
            throw GraphQLError.noData
        }
        return eventsDto
    }
}
