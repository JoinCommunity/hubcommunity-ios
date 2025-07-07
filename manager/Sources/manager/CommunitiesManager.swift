import api
import Foundation
import models
import storage

// MARK: - Communities Manager Protocol

public protocol CommunitiesManagerProtocol: Sendable {
    func fetchCommunities() async throws -> [Community]
    func fetchCommunitiesWithCache() async throws -> [Community]
    func refreshCommunities() async throws -> [Community]
    func getCachedCommunities() async throws -> [Community]
    func clearCache() async throws
}

// MARK: - Communities Manager Implementation

public class CommunitiesManager: CommunitiesManagerProtocol, @unchecked Sendable {
    private let communitiesService: CommunitiesServiceProtocol
    private let storageService: StorageServiceProtocol

    public init(
        communitiesService: CommunitiesServiceProtocol = CommunitiesService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.communitiesService = communitiesService
        self.storageService = storageService
    }

    // MARK: - Public Methods

    /// Fetches communities directly from the API without caching
    public func fetchCommunities() async throws -> [Community] {
        let communityDtos = try await communitiesService.getCommunities()
        return CommunityMapper.map(communityDtos)
    }

    /// Fetches communities with cache-first strategy
    public func fetchCommunitiesWithCache() async throws -> [Community] {
        // First, try to get cached communities
        if let cachedCommunities = try? await getCachedCommunities(), !cachedCommunities.isEmpty {
            // Return cached communities immediately
            return cachedCommunities
        }

        // If no cache or empty cache, fetch from API
        let communities = try await fetchCommunities()

        // Cache the fetched communities
        try await cacheCommunities(communities)

        return communities
    }

    /// Refreshes communities from API and updates cache
    public func refreshCommunities() async throws -> [Community] {
        // Fetch fresh data from API
        let communities = try await fetchCommunities()

        // Update cache with fresh data
        try await cacheCommunities(communities)

        return communities
    }

    /// Gets cached communities from storage
    public func getCachedCommunities() async throws -> [Community] {
        try await storageService.getCommunities()
    }

    /// Clears the communities cache
    public func clearCache() async throws {
        try await storageService.clearCommunities()
    }

    // MARK: - Private Methods

    private func cacheCommunities(_ communities: [Community]) async throws {
        try await storageService.saveCommunities(communities)
    }
}
