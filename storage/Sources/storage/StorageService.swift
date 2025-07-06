import Foundation
import models

// MARK: - Storage Service Protocol

public protocol StorageServiceProtocol: Sendable {
    func saveEvents(_ events: [Event]) async throws
    func getEvents() async throws -> [Event]
    func clearEvents() async throws
}

// MARK: - Storage Service Implementation

public class StorageService: StorageServiceProtocol, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let eventsKey = "cached_events"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func saveEvents(_ events: [Event]) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(events)
        userDefaults.set(data, forKey: eventsKey)
    }

    public func getEvents() async throws -> [Event] {
        guard let data = userDefaults.data(forKey: eventsKey) else {
            return []
        }

        let decoder = JSONDecoder()
        return try decoder.decode([Event].self, from: data)
    }

    public func clearEvents() async throws {
        userDefaults.removeObject(forKey: eventsKey)
    }
}

// MARK: - Mock Storage Service for Testing

public class MockStorageService: StorageServiceProtocol, @unchecked Sendable {
    public var mockEvents: [Event] = []
    public var shouldThrowError = false
    public var mockError: Error = NSError(domain: "MockStorage", code: -1, userInfo: nil)

    public init() {}

    public func saveEvents(_ events: [Event]) async throws {
        if shouldThrowError {
            throw mockError
        }
        mockEvents = events
    }

    public func getEvents() async throws -> [Event] {
        if shouldThrowError {
            throw mockError
        }
        return mockEvents
    }

    public func clearEvents() async throws {
        if shouldThrowError {
            throw mockError
        }
        mockEvents = []
    }
}
