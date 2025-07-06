import Foundation

public protocol GenericGraphQLServiceProtocol: Sendable {
    func execute<T: Codable>(query: String, responseType: T.Type) async throws -> T
}

public class GenericGraphQLService: GenericGraphQLServiceProtocol, @unchecked Sendable {
    private let graphQLClient: GraphQLClientProtocol

    public init(graphQLClient: GraphQLClientProtocol = GraphQLClient()) {
        self.graphQLClient = graphQLClient
    }

    public func execute<T: Codable>(query: String, responseType: T.Type) async throws -> T {
        try await graphQLClient.execute(query: query, responseType: responseType)
    }
}

// MARK: - Convenience Extensions for Common Operations

public extension GenericGraphQLService {
    func fetchEvents() async throws -> [EventDto] {
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
                title
              }
              location {
                title
              }
              images
              communities {
                members_quantity
                title
              }
            }
          }
        }
        """

        let response: EventsQueryDto = try await execute(query: query, responseType: EventsQueryDto.self)

        guard let eventsDto = response.events?.data else {
            throw GraphQLError.noData
        }

        return eventsDto
    }

    // Example of how to add new entities in the future:
    // func fetchCommunities() async throws -> [CommunityDto] {
    //     let query = """
    //     query Communities {
    //       communities {
    //         data {
    //           id
    //           title
    //           members_quantity
    //         }
    //       }
    //     }
    //     """
    //
    //     let response: CommunitiesQueryDto = try await execute(query: query, responseType:
    //     CommunitiesQueryDto.self)
    //     // Return DTOs directly
    //     return response.communities?.data ?? []
    // }
}
