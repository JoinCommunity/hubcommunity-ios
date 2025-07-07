import api
@testable import manager
import models
import storage
import XCTest

final class CommunitiesManagerTests: XCTestCase {
    var communitiesManager: CommunitiesManager!
    fileprivate var mockCommunitiesService: MockCommunitiesService!
    var mockStorageService: MockStorageService!

    override func setUp() {
        super.setUp()
        mockCommunitiesService = MockCommunitiesService()
        mockStorageService = MockStorageService()
        communitiesManager = CommunitiesManager(
            communitiesService: mockCommunitiesService,
            storageService: mockStorageService
        )
    }

    override func tearDown() {
        communitiesManager = nil
        mockCommunitiesService = nil
        mockStorageService = nil
        super.tearDown()
    }

    // MARK: - fetchCommunities Tests

    func testFetchCommunities_Success() async throws {
        // Given
        let mockCommunityDtos = [
            CommunityDto(
                id: "1",
                title: "Test Community 1",
                images: ["image1.jpg"],
                membersQuantity: 100,
                shortDescription: "Test description 1",
                tags: []
            ),
            CommunityDto(
                id: "2",
                title: "Test Community 2",
                images: ["image2.jpg"],
                membersQuantity: 200,
                shortDescription: "Test description 2",
                tags: []
            )
        ]
        mockCommunitiesService.mockCommunities = mockCommunityDtos

        // When
        let result = try await communitiesManager.fetchCommunities()

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Test Community 1")
        XCTAssertEqual(result[0].membersQuantity, 100)
        XCTAssertEqual(result[1].id, "2")
        XCTAssertEqual(result[1].title, "Test Community 2")
        XCTAssertEqual(result[1].membersQuantity, 200)
    }

    func testFetchCommunities_ServiceError() async {
        // Given
        mockCommunitiesService.shouldThrowError = true

        // When & Then
        do {
            _ = try await communitiesManager.fetchCommunities()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }

    // MARK: - fetchCommunitiesWithCache Tests

    func testFetchCommunitiesWithCache_ReturnsCachedData() async throws {
        // Given
        let cachedCommunities = [
            Community(id: "1", title: "Cached Community", membersQuantity: 50)
        ]
        mockStorageService.mockCommunities = cachedCommunities

        // When
        let result = try await communitiesManager.fetchCommunitiesWithCache()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Cached Community")
        XCTAssertEqual(result[0].membersQuantity, 50)
        XCTAssertEqual(mockCommunitiesService.getCommunitiesCallCount, 0)
    }

    func testFetchCommunitiesWithCache_EmptyCache_FetchesFromAPI() async throws {
        // Given
        mockStorageService.mockCommunities = []
        let mockCommunityDtos = [
            CommunityDto(
                id: "1",
                title: "API Community",
                images: ["image1.jpg"],
                membersQuantity: 75,
                shortDescription: "API description",
                tags: []
            )
        ]
        mockCommunitiesService.mockCommunities = mockCommunityDtos

        // When
        let result = try await communitiesManager.fetchCommunitiesWithCache()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "API Community")
        XCTAssertEqual(result[0].membersQuantity, 75)
        XCTAssertEqual(mockCommunitiesService.getCommunitiesCallCount, 1)
        XCTAssertEqual(mockStorageService.mockCommunities.count, 1)
    }

    func testFetchCommunitiesWithCache_StorageError_FetchesFromAPI() async throws {
        // Given
        // Create a custom mock that only throws on getCommunities but not on saveCommunities
        let customMockStorageService = CustomMockStorageService()
        customMockStorageService.shouldThrowOnGet = true
        customMockStorageService.shouldThrowOnSave = false

        let customCommunitiesManager = CommunitiesManager(
            communitiesService: mockCommunitiesService,
            storageService: customMockStorageService
        )

        let mockCommunityDtos = [
            CommunityDto(
                id: "1",
                title: "API Community",
                images: ["image1.jpg"],
                membersQuantity: 75,
                shortDescription: "API description",
                tags: []
            )
        ]
        mockCommunitiesService.mockCommunities = mockCommunityDtos

        // When
        let result = try await customCommunitiesManager.fetchCommunitiesWithCache()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "API Community")
        XCTAssertEqual(result[0].membersQuantity, 75)
        XCTAssertEqual(mockCommunitiesService.getCommunitiesCallCount, 1)
        XCTAssertEqual(customMockStorageService.mockCommunities.count, 1)
    }

    // MARK: - refreshCommunities Tests

    func testRefreshCommunities_Success() async throws {
        // Given
        let mockCommunityDtos = [
            CommunityDto(
                id: "1",
                title: "Refreshed Community",
                images: ["image1.jpg"],
                membersQuantity: 150,
                shortDescription: "Refreshed description",
                tags: []
            )
        ]
        mockCommunitiesService.mockCommunities = mockCommunityDtos

        // When
        let result = try await communitiesManager.refreshCommunities()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Refreshed Community")
        XCTAssertEqual(result[0].membersQuantity, 150)
        XCTAssertEqual(mockCommunitiesService.getCommunitiesCallCount, 1)
        XCTAssertEqual(mockStorageService.mockCommunities.count, 1)
    }

    func testRefreshCommunities_ServiceError() async {
        // Given
        mockCommunitiesService.shouldThrowError = true

        // When & Then
        do {
            _ = try await communitiesManager.refreshCommunities()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is MockError)
        }
    }

    // MARK: - getCachedCommunities Tests

    func testGetCachedCommunities_Success() async throws {
        // Given
        let cachedCommunities = [
            Community(id: "1", title: "Cached Community 1", membersQuantity: 50),
            Community(id: "2", title: "Cached Community 2", membersQuantity: 100)
        ]
        mockStorageService.mockCommunities = cachedCommunities

        // When
        let result = try await communitiesManager.getCachedCommunities()

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Cached Community 1")
        XCTAssertEqual(result[0].membersQuantity, 50)
        XCTAssertEqual(result[1].id, "2")
        XCTAssertEqual(result[1].title, "Cached Community 2")
        XCTAssertEqual(result[1].membersQuantity, 100)
    }

    func testGetCachedCommunities_StorageError() async {
        // Given
        mockStorageService.shouldThrowError = true

        // When & Then
        do {
            _ = try await communitiesManager.getCachedCommunities()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is Error)
        }
    }

    // MARK: - clearCache Tests

    func testClearCache_Success() async throws {
        // Given
        mockStorageService.mockCommunities = [Community(id: "1", title: "Test", membersQuantity: 10)]

        // When
        try await communitiesManager.clearCache()

        // Then
        XCTAssertEqual(mockStorageService.clearCommunitiesCallCount, 1)
    }

    func testClearCache_StorageError() async {
        // Given
        mockStorageService.shouldThrowError = true

        // When & Then
        do {
            try await communitiesManager.clearCache()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is Error)
        }
    }
}

// MARK: - Mock Communities Service

private class MockCommunitiesService: CommunitiesServiceProtocol, @unchecked Sendable {
    var mockCommunities: [CommunityDto] = []
    var shouldThrowError = false
    var getCommunitiesCallCount = 0

    func getCommunities() async throws -> [CommunityDto] {
        getCommunitiesCallCount += 1

        if shouldThrowError {
            throw MockError.testError
        }

        return mockCommunities
    }
}

// MARK: - Mock Error

private enum MockError: Error {
    case testError
}

// MARK: - Custom Mock Storage Service

private class CustomMockStorageService: StorageServiceProtocol, @unchecked Sendable {
    public var mockEvents: [Event] = []
    public var mockCommunities: [Community] = []
    public var shouldThrowOnGet = false
    public var shouldThrowOnSave = false
    public var mockError: Error = NSError(domain: "MockStorage", code: -1, userInfo: nil)
    public var clearEventsCallCount = 0
    public var clearCommunitiesCallCount = 0

    public init() {}

    public func saveEvents(_ events: [Event]) async throws {
        if shouldThrowOnSave {
            throw mockError
        }
        mockEvents = events
    }

    public func getEvents() async throws -> [Event] {
        if shouldThrowOnGet {
            throw mockError
        }
        return mockEvents
    }

    public func clearEvents() async throws {
        if shouldThrowOnGet {
            throw mockError
        }
        clearEventsCallCount += 1
        mockEvents = []
    }

    public func saveCommunities(_ communities: [Community]) async throws {
        if shouldThrowOnSave {
            throw mockError
        }
        mockCommunities = communities
    }

    public func getCommunities() async throws -> [Community] {
        if shouldThrowOnGet {
            throw mockError
        }
        return mockCommunities
    }

    public func clearCommunities() async throws {
        if shouldThrowOnGet {
            throw mockError
        }
        clearCommunitiesCallCount += 1
        mockCommunities = []
    }
}
