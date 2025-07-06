import api
import Foundation
import models
import storage

// MARK: - Enhanced Events Manager Protocol

public protocol EnhancedEventsManagerProtocol: Sendable {
    // Basic operations
    func fetchEvents() async throws -> [Event]
    func fetchEventsWithCache() async throws -> [Event]
    func refreshEvents() async throws -> [Event]
    func getCachedEvents() async throws -> [Event]
    func clearCache() async throws

    // Business logic operations
    func getFilteredEvents(with options: EventFilterOptions) async throws -> [Event]
    func getSortedEvents(by option: EventSortOption) async throws -> [Event]
    func getFilteredAndSortedEvents(
        filterOptions: EventFilterOptions,
        sortOption: EventSortOption
    ) async throws -> [Event]

    // Analytics
    func getEventsStatistics() async throws -> EventsStatistics
    func getUniqueTags() async throws -> [Tag]
    func getUniqueCommunities() async throws -> [Community]

    // Search
    func searchEvents(term: String) async throws -> [Event]
}

// MARK: - Enhanced Events Manager Implementation

public class EnhancedEventsManager: EnhancedEventsManagerProtocol, @unchecked Sendable {
    private let eventsService: EventsServiceProtocol
    private let storageService: StorageServiceProtocol

    public init(
        eventsService: EventsServiceProtocol = EventsService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.eventsService = eventsService
        self.storageService = storageService
    }

    // MARK: - Basic Operations

    public func fetchEvents() async throws -> [Event] {
        try await eventsService.getEvents()
    }

    public func fetchEventsWithCache() async throws -> [Event] {
        // First, try to get cached events
        if let cachedEvents = try? await getCachedEvents(), !cachedEvents.isEmpty {
            // Return cached events immediately
            return cachedEvents
        }

        // If no cache or empty cache, fetch from API
        let events = try await fetchEvents()

        // Cache the fetched events
        try await cacheEvents(events)

        return events
    }

    public func refreshEvents() async throws -> [Event] {
        // Fetch fresh data from API
        let events = try await fetchEvents()

        // Update cache with fresh data
        try await cacheEvents(events)

        return events
    }

    public func getCachedEvents() async throws -> [Event] {
        try await storageService.getEvents()
    }

    public func clearCache() async throws {
        try await storageService.clearEvents()
    }

    // MARK: - Business Logic Operations

    public func getFilteredEvents(with options: EventFilterOptions) async throws -> [Event] {
        let events = try await fetchEventsWithCache()
        return EventsBusinessLogic.filterEvents(events, with: options)
    }

    public func getSortedEvents(by option: EventSortOption) async throws -> [Event] {
        let events = try await fetchEventsWithCache()
        return EventsBusinessLogic.sortEvents(events, by: option)
    }

    public func getFilteredAndSortedEvents(
        filterOptions: EventFilterOptions,
        sortOption: EventSortOption
    ) async throws -> [Event] {
        let events = try await fetchEventsWithCache()
        let filteredEvents = EventsBusinessLogic.filterEvents(events, with: filterOptions)
        return EventsBusinessLogic.sortEvents(filteredEvents, by: sortOption)
    }

    // MARK: - Analytics

    public func getEventsStatistics() async throws -> EventsStatistics {
        let events = try await fetchEventsWithCache()
        return EventsBusinessLogic.getEventsStatistics(from: events)
    }

    public func getUniqueTags() async throws -> [Tag] {
        let events = try await fetchEventsWithCache()
        return EventsBusinessLogic.getUniqueTags(from: events)
    }

    public func getUniqueCommunities() async throws -> [Community] {
        let events = try await fetchEventsWithCache()
        return EventsBusinessLogic.getUniqueCommunities(from: events)
    }

    // MARK: - Search

    public func searchEvents(term: String) async throws -> [Event] {
        let filterOptions = EventFilterOptions(searchTerm: term)
        return try await getFilteredEvents(with: filterOptions)
    }

    // MARK: - Private Methods

    private func cacheEvents(_ events: [Event]) async throws {
        try await storageService.saveEvents(events)
    }
}

// MARK: - Enhanced Manager Factory

public class EnhancedEventsManagerFactory {
    public static func createManager(
        baseURL: URL = URL(string: "https://hubcommunity-bff.8020digital.com.br/graphql")!
    ) -> EnhancedEventsManagerProtocol {
        let eventsService = EventsServiceFactory.createService(baseURL: baseURL)
        let storageService = StorageService()
        return EnhancedEventsManager(eventsService: eventsService, storageService: storageService)
    }

    public static func createMockManager(
        mockEvents: [Event] = [],
        shouldThrowError: Bool = false,
        mockError: Error = GraphQLError.noData
    ) -> EnhancedEventsManagerProtocol {
        let mockEventsService = EventsServiceFactory.createMockService(
            mockEvents: mockEvents,
            shouldThrowError: shouldThrowError,
            mockError: mockError
        )
        let mockStorageService = MockStorageService()
        return EnhancedEventsManager(eventsService: mockEventsService, storageService: mockStorageService)
    }
}
