import Foundation

public class CommunitiesServiceFactory {
    public static func createService(
        baseURL: URL = URL(string: "https://hubcommunity-bff.8020digital.com.br/graphql")!
    ) -> CommunitiesServiceProtocol {
        let client = GraphQLClient(url: baseURL)
        return CommunitiesService(graphQLClient: client)
    }

    public static func createMockService(
        mockCommunities: [CommunityDto] = [],
        shouldThrowError: Bool = false,
        mockError: Error = GraphQLError.noData
    ) -> CommunitiesServiceProtocol {
        let mockClient = MockGraphQLClient(
            mockCommunities: mockCommunities,
            shouldThrowError: shouldThrowError,
            mockError: mockError
        )
        return CommunitiesService(graphQLClient: mockClient)
    }

    public static func createServiceWithCustomClient(
        graphQLClient: GraphQLClientProtocol
    ) -> CommunitiesServiceProtocol {
        CommunitiesService(graphQLClient: graphQLClient)
    }
}
