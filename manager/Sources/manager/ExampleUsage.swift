//
//  ExampleUsage.swift
//  manager
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation
import models

// MARK: - Example Usage
// This file demonstrates how to use the manager layer

public class ManagerExampleUsage {
    
    // MARK: - Basic Manager Usage
    public static func basicManagerUsage() async {
        let manager = EventsManager()
        
        do {
            let events = try await manager.fetchEventsWithCache()
            print("✅ Successfully fetched \(events.count) events with cache")
            
            for event in events {
                print("📅 Event: \(event.title)")
                print("📍 Location: \(event.location.title)")
                print("🏷️ Tags: \(event.tags.map { $0.value }.joined(separator: ", "))")
                print("🎤 Talks: \(event.talks.count)")
                print("👥 Communities: \(event.communities.count)")
                print("---")
            }
        } catch {
            print("❌ Error fetching events: \(error)")
        }
    }
    
    // MARK: - Enhanced Manager Usage
    public static func enhancedManagerUsage() async {
        let manager = EnhancedEventsManager()
        
        do {
            // Search for events
            let searchResults = try await manager.searchEvents(term: "Swift")
            print("🔍 Found \(searchResults.count) events matching 'Swift'")
            
            // Filter events
            let filterOptions = EventFilterOptions(
                searchTerm: "Conference",
                tags: ["Swift", "iOS"],
                hasTalks: true,
                hasImages: true
            )
            let filteredEvents = try await manager.getFilteredEvents(with: filterOptions)
            print("🎯 Found \(filteredEvents.count) filtered events")
            
            // Sort events
            let sortedEvents = try await manager.getSortedEvents(by: .titleAscending)
            print("📊 Sorted \(sortedEvents.count) events by title")
            
            // Get analytics
            let statistics = try await manager.getEventsStatistics()
            print("📈 Analytics:")
            print("   Total events: \(statistics.totalEvents)")
            print("   Total talks: \(statistics.totalTalks)")
            print("   Average talks per event: \(statistics.averageTalksPerEvent)")
            print("   Events with images: \(statistics.eventsWithImagesPercentage)%")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Business Logic Usage
    public static func businessLogicUsage() async {
        let manager = EnhancedEventsManager()
        
        do {
            let events = try await manager.fetchEventsWithCache()
            
            // Get unique tags and communities
            let uniqueTags = try await manager.getUniqueTags()
            let uniqueCommunities = try await manager.getUniqueCommunities()
            
            print("🏷️ Unique tags (\(uniqueTags.count)):")
            for tag in uniqueTags {
                print("   - \(tag.value)")
            }
            
            print("👥 Unique communities (\(uniqueCommunities.count)):")
            for community in uniqueCommunities {
                print("   - \(community.title) (\(community.membersQuantity) members)")
            }
            
            // Combined filtering and sorting
            let filterOptions = EventFilterOptions(
                searchTerm: "Development",
                hasTalks: true
            )
            let sortOption = EventSortOption.communityCountDescending
            
            let result = try await manager.getFilteredAndSortedEvents(
                filterOptions: filterOptions,
                sortOption: sortOption
            )
            
            print("🎯 Filtered and sorted events (\(result.count)):")
            for event in result {
                print("   - \(event.title) (\(event.communities.count) communities)")
            }
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Caching Strategy Usage
    public static func cachingStrategyUsage() async {
        let manager = EventsManager()
        
        do {
            // Cache-first (default behavior)
            print("🔄 Fetching events with cache-first strategy...")
            let events = try await manager.fetchEventsWithCache()
            print("✅ Got \(events.count) events")
            
            // Force refresh from API
            print("🔄 Refreshing events from API...")
            let freshEvents = try await manager.refreshEvents()
            print("✅ Got \(freshEvents.count) fresh events")
            
            // Get only cached events
            print("📦 Getting cached events only...")
            let cachedEvents = try await manager.getCachedEvents()
            print("✅ Got \(cachedEvents.count) cached events")
            
            // Clear cache
            print("🗑️ Clearing cache...")
            try await manager.clearCache()
            print("✅ Cache cleared")
            
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    // MARK: - Error Handling Usage
    public static func errorHandlingUsage() async {
        let manager = EventsManager()
        
        do {
            let events = try await manager.fetchEventsWithCache()
            print("✅ Success: \(events.count) events")
        } catch GraphQLError.noData {
            print("❌ No data received from GraphQL query")
        } catch GraphQLError.networkError(let underlyingError) {
            print("❌ Network error: \(underlyingError)")
        } catch {
            print("❌ Unexpected error: \(error)")
        }
    }
}

// MARK: - ViewModel Example
@MainActor
public class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var statistics: EventsStatistics?
    
    private let manager: EnhancedEventsManagerProtocol
    
    public init(manager: EnhancedEventsManagerProtocol = EnhancedEventsManager()) {
        self.manager = manager
    }
    
    public func loadEvents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            events = try await manager.fetchEventsWithCache()
            statistics = try await manager.getEventsStatistics()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func searchEvents(term: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            events = try await manager.searchEvents(term: term)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func filterEvents(options: EventFilterOptions) async {
        isLoading = true
        errorMessage = nil
        
        do {
            events = try await manager.getFilteredEvents(with: options)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    public func sortEvents(by option: EventSortOption) async {
        isLoading = true
        errorMessage = nil
        
        do {
            events = try await manager.getSortedEvents(by: option)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
} 