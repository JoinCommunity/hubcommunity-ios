@testable import api
import XCTest

final class EventsServiceTests: XCTestCase {

    func testEventsServiceReturnsEvents() async throws {
        // Given
        let mockEvents = [
            EventDto(
                id: "1",
                title: "Test Event",
                tags: [TagDto(id: "1", value: "Swift")],
                talks: [TalkDto(id: "1", title: "Test Talk")],
                location: LocationDto(id: "1", title: "Test Location"),
                images: ["image1.jpg"],
                communities: [CommunityDto(
                    id: "1",
                    title: "Test Community",
                    images: [],
                    membersQuantity: 100,
                    shortDescription: "Test",
                    tags: []
                )]
            )
        ]

        let mockClient = MockGraphQLClient(mockEvents: mockEvents)
        let service = EventsService(graphQLClient: mockClient)

        // When
        let result = try await service.getEvents()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(result.first?.title, "Test Event")
    }

    func testEventsServicePropagatesError() async {
        // Given
        let mockError = GraphQLError.noData
        let mockClient = MockGraphQLClient(shouldThrowError: true, mockError: mockError)
        let service = EventsService(graphQLClient: mockClient)

        // When & Then
        do {
            _ = try await service.getEvents()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GraphQLError, mockError)
        }
    }

    func testEventsServiceFactoryCreatesService() {
        // Given
        let url = URL(string: "https://test.com/graphql")!

        // When
        let service = EventsServiceFactory.createService(baseURL: url)

        // Then
        XCTAssertNotNil(service)
        XCTAssertTrue(service is EventsService)
    }

    func testEventsServiceFactoryCreatesMockService() {
        // Given
        let mockEvents = [
            EventDto(
                id: "1",
                title: "Test Event",
                tags: [],
                talks: [],
                location: LocationDto(id: "1", title: "Test"),
                images: [],
                communities: []
            )
        ]

        // When
        let service = EventsServiceFactory.createMockService(mockEvents: mockEvents)

        // Then
        XCTAssertNotNil(service)
        XCTAssertTrue(service is EventsService)
    }

    func testEventsServiceDefaultInitializer() {
        // When
        let service = EventsService()

        // Then
        XCTAssertNotNil(service)
    }
}
