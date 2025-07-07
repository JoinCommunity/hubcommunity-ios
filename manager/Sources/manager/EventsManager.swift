import api
import Foundation
import models
import storage

// MARK: - Events Manager Protocol

public protocol EventsManagerProtocol: Sendable {
    func fetchEvents() async throws -> [Event]
    func fetchEventsWithCache() async throws -> [Event]
    func refreshEvents() async throws -> [Event]
    func getCachedEvents() async throws -> [Event]
    func clearCache() async throws
}

// MARK: - Events Manager Implementation

public class EventsManager: EventsManagerProtocol, @unchecked Sendable {
    private let eventsService: EventsServiceProtocol
    private let storageService: StorageServiceProtocol

    public init(
        eventsService: EventsServiceProtocol = EventsService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.eventsService = eventsService
        self.storageService = storageService
    }

    // MARK: - Public Methods

    /// Fetches events directly from the API without caching
    public func fetchEvents() async throws -> [Event] {
        let eventDtos = try await eventsService.getEvents()
        return EventsMapper.map(eventDtos)
    }

    /// Fetches events with cache-first strategy
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

    /// Refreshes events from API and updates cache
    public func refreshEvents() async throws -> [Event] {
        // Fetch fresh data from API
        let events = try await fetchEvents()

        // Update cache with fresh data
        try await cacheEvents(events)

        return events
    }

    /// Gets cached events from storage
    public func getCachedEvents() async throws -> [Event] {
        try await storageService.getEvents()
    }

    /// Clears the events cache
    public func clearCache() async throws {
        try await storageService.clearEvents()
    }

    // MARK: - Private Methods

    private func cacheEvents(_ events: [Event]) async throws {
        try await storageService.saveEvents(events)
    }
}
