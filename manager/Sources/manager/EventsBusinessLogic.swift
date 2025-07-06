import Foundation
import models

// MARK: - Event Filtering Options

public struct EventFilterOptions: Sendable {
    public let searchTerm: String?
    public let tags: [String]?
    public let communities: [String]?
    public let hasTalks: Bool?
    public let hasImages: Bool?

    public init(
        searchTerm: String? = nil,
        tags: [String]? = nil,
        communities: [String]? = nil,
        hasTalks: Bool? = nil,
        hasImages: Bool? = nil
    ) {
        self.searchTerm = searchTerm
        self.tags = tags
        self.communities = communities
        self.hasTalks = hasTalks
        self.hasImages = hasImages
    }
}

// MARK: - Event Sorting Options

public enum EventSortOption: Sendable {
    case titleAscending
    case titleDescending
    case communityCountAscending
    case communityCountDescending
    case talkCountAscending
    case talkCountDescending
}

// MARK: - Events Business Logic

public class EventsBusinessLogic {

    // MARK: - Filtering

    /// Filters events based on the provided options
    public static func filterEvents(_ events: [Event], with options: EventFilterOptions) -> [Event] {
        events.filter { event in
            // Search term filter
            if let searchTerm = options.searchTerm, !searchTerm.isEmpty {
                let searchLower = searchTerm.lowercased()
                let matchesTitle = event.title.lowercased().contains(searchLower)
                let matchesLocation = event.location.title.lowercased().contains(searchLower)
                let matchesTags = event.tags.contains { $0.value.lowercased().contains(searchLower) }
                let matchesCommunities = event.communities.contains { $0.title.lowercased().contains(searchLower) }

                if !matchesTitle, !matchesLocation, !matchesTags, !matchesCommunities {
                    return false
                }
            }

            // Tags filter
            if let tags = options.tags, !tags.isEmpty {
                let eventTagValues = Set(event.tags.map { $0.value.lowercased() })
                let filterTagValues = Set(tags.map { $0.lowercased() })
                if eventTagValues.intersection(filterTagValues).isEmpty {
                    return false
                }
            }

            // Communities filter
            if let communities = options.communities, !communities.isEmpty {
                let eventCommunityTitles = Set(event.communities.map { $0.title.lowercased() })
                let filterCommunityTitles = Set(communities.map { $0.lowercased() })
                if eventCommunityTitles.intersection(filterCommunityTitles).isEmpty {
                    return false
                }
            }

            // Has talks filter
            if let hasTalks = options.hasTalks {
                if hasTalks, event.talks.isEmpty {
                    return false
                }
                if !hasTalks, !event.talks.isEmpty {
                    return false
                }
            }

            // Has images filter
            if let hasImages = options.hasImages {
                if hasImages, event.images.isEmpty {
                    return false
                }
                if !hasImages, !event.images.isEmpty {
                    return false
                }
            }

            return true
        }
    }

    // MARK: - Sorting

    /// Sorts events based on the provided option
    public static func sortEvents(_ events: [Event], by option: EventSortOption) -> [Event] {
        events.sorted { event1, event2 in
            switch option {
            case .titleAscending:
                event1.title.localizedCaseInsensitiveCompare(event2.title) == .orderedAscending

            case .titleDescending:
                event1.title.localizedCaseInsensitiveCompare(event2.title) == .orderedDescending

            case .communityCountAscending:
                event1.communities.count < event2.communities.count

            case .communityCountDescending:
                event1.communities.count > event2.communities.count

            case .talkCountAscending:
                event1.talks.count < event2.talks.count

            case .talkCountDescending:
                event1.talks.count > event2.talks.count
            }
        }
    }

    // MARK: - Analytics and Insights

    /// Gets unique tags from all events
    public static func getUniqueTags(from events: [Event]) -> [Tag] {
        let allTags = events.flatMap(\.tags)
        let uniqueTags = Dictionary(grouping: allTags) { $0.id }
        return Array(uniqueTags.values.map { $0.first! })
    }

    /// Gets unique communities from all events
    public static func getUniqueCommunities(from events: [Event]) -> [Community] {
        let allCommunities = events.flatMap(\.communities)
        let uniqueCommunities = Dictionary(grouping: allCommunities) { $0.id }
        return Array(uniqueCommunities.values.map { $0.first! })
    }

    /// Gets events statistics
    public static func getEventsStatistics(from events: [Event]) -> EventsStatistics {
        let totalEvents = events.count
        let totalTalks = events.reduce(0) { $0 + $1.talks.count }
        let totalCommunities = events.reduce(0) { $0 + $1.communities.count }
        let eventsWithImages = events.filter { !$0.images.isEmpty }.count
        let eventsWithTalks = events.filter { !$0.talks.isEmpty }.count

        return EventsStatistics(
            totalEvents: totalEvents,
            totalTalks: totalTalks,
            totalCommunities: totalCommunities,
            eventsWithImages: eventsWithImages,
            eventsWithTalks: eventsWithTalks
        )
    }
}

// MARK: - Events Statistics

public struct EventsStatistics: Sendable {
    public let totalEvents: Int
    public let totalTalks: Int
    public let totalCommunities: Int
    public let eventsWithImages: Int
    public let eventsWithTalks: Int

    public var averageTalksPerEvent: Double {
        guard totalEvents > 0 else {
            return 0
        }
        return Double(totalTalks) / Double(totalEvents)
    }

    public var averageCommunitiesPerEvent: Double {
        guard totalEvents > 0 else {
            return 0
        }
        return Double(totalCommunities) / Double(totalEvents)
    }

    public var eventsWithImagesPercentage: Double {
        guard totalEvents > 0 else {
            return 0
        }
        return (Double(eventsWithImages) / Double(totalEvents)) * 100
    }

    public var eventsWithTalksPercentage: Double {
        guard totalEvents > 0 else {
            return 0
        }
        return (Double(eventsWithTalks) / Double(totalEvents)) * 100
    }
}
