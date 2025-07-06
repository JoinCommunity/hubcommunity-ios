import Foundation

public protocol GraphQLClientProtocol: Sendable {
    func execute<T: Codable>(query: String, responseType: T.Type) async throws -> T
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

    public func execute<T: Codable>(query: String, responseType: T.Type) async throws -> T {
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

        let graphQLResponse = try JSONDecoder().decode(GraphQLResponse<T>.self, from: data)

        guard let responseData = graphQLResponse.data else {
            throw GraphQLError.noData
        }

        return responseData
    }
}

public class MockGraphQLClient: GraphQLClientProtocol, @unchecked Sendable {
    private let mockEvents: [EventDto]
    private let shouldThrowError: Bool
    private let mockError: Error

    public init(
        mockEvents: [EventDto] = [],
        shouldThrowError: Bool = false,
        mockError: Error = GraphQLError.noData
    ) {
        self.mockEvents = mockEvents
        self.shouldThrowError = shouldThrowError
        self.mockError = mockError
    }

    public func execute<T: Codable>(query: String, responseType: T.Type) async throws -> T {
        if shouldThrowError {
            throw mockError
        }
        // For mock purposes, we'll return a default response based on the type
        if T.self == EventsQueryDto.self {
            let mockResponse = EventsQueryDto(
                events: EventsDto(data: mockEvents)
            )
            return mockResponse as! T
        }
        throw GraphQLError.noData
    }
}
