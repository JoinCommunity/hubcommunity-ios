import XCTest
@testable import manager
import api
import models
import storage

final class EventsManagerTests: XCTestCase {
    
    func testFetchEvents() async throws {
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
        
        let mockService = EventsServiceFactory.createMockService(mockEvents: mockEvents)
        let mockStorage = MockStorageService()
        let manager = EventsManager(eventsService: mockService, storageService: mockStorage)
        
        // When
        let result = try await manager.fetchEvents()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(result.first?.title, "Test Event")
    }
    
    func testFetchEventsWithCache() async throws {
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
        
        let mockService = EventsServiceFactory.createMockService(mockEvents: mockEvents)
        let mockStorage = MockStorageService()
        mockStorage.mockEvents = mockEvents
        
        let manager = EventsManager(eventsService: mockService, storageService: mockStorage)
        
        // When
        let result = try await manager.fetchEventsWithCache()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
    
    func testRefreshEvents() async throws {
        // Given
        let mockEvents = [
            Event(
                id: "1",
                title: "Refreshed Event",
                tags: [],
                talks: [],
                location: Location(id: "1", title: "Test"),
                images: [],
                communities: []
            )
        ]
        
        let mockService = EventsServiceFactory.createMockService(mockEvents: mockEvents)
        let mockStorage = MockStorageService()
        let manager = EventsManager(eventsService: mockService, storageService: mockStorage)
        
        // When
        let result = try await manager.refreshEvents()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Refreshed Event")
    }
    
    func testGetCachedEvents() async throws {
        // Given
        let mockEvents = [
            Event(
                id: "1",
                title: "Cached Event",
                tags: [],
                talks: [],
                location: Location(id: "1", title: "Test"),
                images: [],
                communities: []
            )
        ]
        
        let mockStorage = MockStorageService()
        mockStorage.mockEvents = mockEvents
        let manager = EventsManager(storageService: mockStorage)
        
        // When
        let result = try await manager.getCachedEvents()
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Cached Event")
    }
    
    func testClearCache() async throws {
        // Given
        let mockStorage = MockStorageService()
        let manager = EventsManager(storageService: mockStorage)
        
        // When & Then
        do {
            try await manager.clearCache()
            // Should not throw
        } catch {
            XCTFail("clearCache should not throw: \(error)")
        }
    }
    
    func testManagerFactoryCreatesManager() {
        // Given
        let url = URL(string: "https://test.com/graphql")!
        
        // When
        let manager = EventsManagerFactory.createManager(baseURL: url)
        
        // Then
        XCTAssertNotNil(manager)
        XCTAssertTrue(manager is EventsManager)
    }
    
    func testManagerFactoryCreatesMockManager() {
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
        let manager = EventsManagerFactory.createMockManager(mockEvents: mockEvents)
        
        // Then
        XCTAssertNotNil(manager)
        XCTAssertTrue(manager is EventsManager)
    }
} 