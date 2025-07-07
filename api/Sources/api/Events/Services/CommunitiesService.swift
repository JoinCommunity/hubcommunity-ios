import Foundation

public protocol CommunitiesServiceProtocol: Sendable {
    func getCommunities() async throws -> [CommunityDto]
}

public class CommunitiesService: CommunitiesServiceProtocol, @unchecked Sendable {
    private let graphQLClient: GraphQLClientProtocol

    public init(graphQLClient: GraphQLClientProtocol = GraphQLClient()) {
        self.graphQLClient = graphQLClient
    }

    public func getCommunities() async throws -> [CommunityDto] {
        let query = """
        query Data {
          communities {
            data {
              id
              title
              images
              members_quantity
              short_description
              tags {
                id
                value
              }
            }
          }
        }
        """
        let response: CommunitiesQueryDto = try await graphQLClient.execute(
            query: query,
            responseType: CommunitiesQueryDto.self
        )
        guard let communitiesDto = response.communities?.data else {
            throw GraphQLError.noData
        }
        return communitiesDto
    }
}
