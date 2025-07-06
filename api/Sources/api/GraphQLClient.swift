import Foundation
import models

// MARK: - Protocol for testability

public protocol GraphQLClientProtocol: Sendable {
    func fetchEvents() async throws -> [Event]
}

// MARK: - GraphQL Client Implementation

public class GraphQLClient: GraphQLClientProtocol, @unchecked Sendable {
    private let baseURL: URL
    private let session: URLSession

    public init(url: URL, session: URLSession = .shared) {
        baseURL = url
        self.session = session
    }

    public convenience init() {
        let url = URL(string: "https://hubcommunity-bff.8020digital.com.br/graphql")!
        self.init(url: url)
    }

    public func fetchEvents() async throws -> [Event] {
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

        let requestBody = GraphQLRequest(query: query)
        let jsonData = try JSONEncoder().encode(requestBody)

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GraphQLError.networkError(NSError(
                domain: "GraphQL",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid response type"]
            ))
        }

        guard httpResponse.statusCode == 200 else {
            throw GraphQLError.networkError(NSError(
                domain: "GraphQL",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode)"]
            ))
        }

        let graphQLResponse = try JSONDecoder().decode(GraphQLResponse.self, from: data)

        guard let eventsData = graphQLResponse.data?.events?.data else {
            throw GraphQLError.noData
        }

        return eventsData.compactMap { eventData -> Event? in
            guard
                let id = eventData.id,
                let title = eventData.title
            else {
                return nil
            }

            let tags = eventData.tags?.compactMap { tagData -> Tag? in
                guard
                    let tagId = tagData.id,
                    let value = tagData.value
                else {
                    return nil
                }
                return Tag(id: tagId, value: value)
            } ?? []

            let talks = eventData.talks?.compactMap { talkData -> Talk? in
                guard
                    let talkId = talkData.id,
                    let talkTitle = talkData.title
                else {
                    return nil
                }
                return Talk(id: talkId, title: talkTitle)
            } ?? []

            let location = Location(
                id: eventData.location?.id ?? "",
                title: eventData.location?.title ?? ""
            )

            let images = eventData.images ?? []

            let communities = eventData.communities?.compactMap { communityData -> Community? in
                guard
                    let communityId = communityData.id,
                    let communityTitle = communityData.title
                else {
                    return nil
                }
                return Community(
                    id: communityId,
                    title: communityTitle,
                    membersQuantity: communityData.membersQuantity ?? 0
                )
            } ?? []

            return Event(
                id: id,
                title: title,
                tags: tags,
                talks: talks,
                location: location,
                images: images,
                communities: communities
            )
        }
    }
}

// MARK: - Mock Client for Testing

public class MockGraphQLClient: GraphQLClientProtocol, @unchecked Sendable {
    private let mockEvents: [Event]
    private let shouldThrowError: Bool
    private let mockError: Error

    public init(
        mockEvents: [Event] = [],
        shouldThrowError: Bool = false,
        mockError: Error = GraphQLError.noData
    ) {
        self.mockEvents = mockEvents
        self.shouldThrowError = shouldThrowError
        self.mockError = mockError
    }

    public func fetchEvents() async throws -> [Event] {
        if shouldThrowError {
            throw mockError
        }
        return mockEvents
    }
}
