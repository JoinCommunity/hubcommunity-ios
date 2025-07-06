import XCTest
@testable import api
import models

final class EventsServiceTests: XCTestCase {
    
    func testEventsServiceReturnsEvents() async throws {
        // Given
        let mockEvents = [
            Event(
                id: "1",
                title: "Test Event",
                tags: [Tag(id: "1", value: "Swift")],
                talks: [Talk(id: "1", title: "Test Talk")],
                location: Location(id: "1", title: "Test Location"),
                images: ["image1.jpg"],
                communities: [Community(id: "1", title: "Test Community", membersQuantity: 100)]
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
            Event(
                id: "1",
                title: "Test Event",
                tags: [],
                talks: [],
                location: Location(id: "1", title: "Test"),
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