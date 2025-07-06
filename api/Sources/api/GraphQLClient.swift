import Foundation
import models

public protocol GraphQLClientProtocol: Sendable {
    func fetchEvents() async throws -> [Event]
}

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

        let graphQLResponse = try JSONDecoder().decode(GraphQLResponse<EventsQueryDto>.self, from: data)

        guard let eventsDto = graphQLResponse.data?.events?.data else {
            throw GraphQLError.noData
        }

        return eventsDto.compactMap { eventDto -> Event? in
            guard
                let id = eventDto.id,
                let title = eventDto.title
            else {
                return nil
            }

            let tags = eventDto.tags?.compactMap { tagDto -> Tag? in
                guard
                    let tagId = tagDto.id,
                    let value = tagDto.value
                else {
                    return nil
                }
                return Tag(id: tagId, value: value)
            } ?? []

            let talks = eventDto.talks?.compactMap { talkDto -> Talk? in
                guard
                    let talkId = talkDto.id,
                    let talkTitle = talkDto.title
                else {
                    return nil
                }
                return Talk(id: talkId, title: talkTitle)
            } ?? []

            let location = Location(
                id: eventDto.location?.id ?? "",
                title: eventDto.location?.title ?? ""
            )

            let images = eventDto.images ?? []

            let communities = eventDto.communities?.compactMap { communityDto -> Community? in
                guard
                    let communityId = communityDto.id,
                    let communityTitle = communityDto.title
                else {
                    return nil
                }
                return Community(
                    id: communityId,
                    title: communityTitle,
                    membersQuantity: communityDto.membersQuantity ?? 0
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
