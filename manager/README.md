# Hub Community Manager Package

This package provides the business logic layer for the Hub Community app, acting as the intermediary between the UI and the API/storage layers.

## Features

- ✅ Business logic layer with caching strategies
- ✅ Event filtering and sorting capabilities
- ✅ Analytics and insights
- ✅ Search functionality
- ✅ Protocol-based architecture for testability
- ✅ Mock implementations for testing

## Architecture

The manager layer sits between the UI and the underlying layers:

```
UI Layer
    ↓
Manager Layer (Business Logic)
    ↓
API Layer (GraphQL Client)
Storage Layer (Local Cache)
```

## Installation

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(path: "path/to/manager")
]
```

## Usage

### Basic Usage

```swift
import manager

// Create a manager instance
let eventsManager = EventsManager()

// Fetch events with cache-first strategy
do {
    let events = try await eventsManager.fetchEventsWithCache()
    print("Found \(events.count) events")
} catch {
    print("Error fetching events: \(error)")
}
```

### Enhanced Manager with Business Logic

```swift
import manager

// Create an enhanced manager with business logic
let enhancedManager = EnhancedEventsManager()

// Search for events
let searchResults = try await enhancedManager.searchEvents(term: "Swift")

// Filter events
let filterOptions = EventFilterOptions(
    searchTerm: "Conference",
    tags: ["Swift", "iOS"],
    hasTalks: true,
    hasImages: true
)
let filteredEvents = try await enhancedManager.getFilteredEvents(with: filterOptions)

// Sort events
let sortedEvents = try await enhancedManager.getSortedEvents(by: .titleAscending)

// Get analytics
let statistics = try await enhancedManager.getEventsStatistics()
print("Average talks per event: \(statistics.averageTalksPerEvent)")
```

### Using the Factory

```swift
import manager

// Create manager with custom URL
let customURL = URL(string: "https://your-custom-endpoint.com/graphql")!
let manager = EventsManagerFactory.createManager(baseURL: customURL)

// Create mock manager for testing
let mockManager = EventsManagerFactory.createMockManager(mockEvents: [
    Event(
        id: "1",
        title: "Test Event",
        tags: [Tag(id: "1", value: "Swift")],
        talks: [Talk(id: "1", title: "Test Talk")],
        location: Location(id: "1", title: "Test Location"),
        images: ["image1.jpg"],
        communities: [Community(id: "1", title: "Test Community", membersQuantity: 100)]
    )
])
```

### Business Logic Operations

```swift
import manager

// Filter options
let filterOptions = EventFilterOptions(
    searchTerm: "Conference",
    tags: ["Swift"],
    communities: ["iOS Developers"],
    hasTalks: true,
    hasImages: false
)

// Sort options
let sortOption = EventSortOption.titleAscending

// Combined filtering and sorting
let events = try await enhancedManager.getFilteredAndSortedEvents(
    filterOptions: filterOptions,
    sortOption: sortOption
)

// Get unique tags and communities
let uniqueTags = try await enhancedManager.getUniqueTags()
let uniqueCommunities = try await enhancedManager.getUniqueCommunities()
```

## Caching Strategy

The manager implements a cache-first strategy:

1. **Cache-First**: Returns cached data immediately if available
2. **API Fallback**: Fetches from API if cache is empty or invalid
3. **Cache Update**: Automatically updates cache with fresh data
4. **Manual Refresh**: Allows forcing refresh from API

```swift
// Cache-first (default)
let events = try await manager.fetchEventsWithCache()

// Force refresh from API
let freshEvents = try await manager.refreshEvents()

// Get only cached events
let cachedEvents = try await manager.getCachedEvents()

// Clear cache
try await manager.clearCache()
```

## Business Logic Features

### Filtering

- **Search**: Search across title, location, tags, and communities
- **Tags**: Filter by specific tags
- **Communities**: Filter by specific communities
- **Content**: Filter by presence of talks or images

### Sorting

- **Title**: Ascending/descending
- **Community Count**: Ascending/descending
- **Talk Count**: Ascending/descending

### Analytics

- **Statistics**: Total events, talks, communities
- **Averages**: Talks per event, communities per event
- **Percentages**: Events with images, events with talks

## Testing

### Unit Tests

The package includes comprehensive unit tests. Run them with:

```bash
swift test
```

### Mock Manager for Testing

```swift
import manager

class YourViewControllerTests: XCTestCase {
    func testFetchEvents() async throws {
        // Given
        let mockEvents = [/* your mock events */]
        let mockManager = EventsManagerFactory.createMockManager(mockEvents: mockEvents)
        
        // When
        let events = try await mockManager.fetchEventsWithCache()
        
        // Then
        XCTAssertEqual(events.count, mockEvents.count)
    }
}
```

## Dependencies

The manager package depends on:

- **api**: For GraphQL client and service layer
- **models**: For data structures
- **storage**: For local caching

## Error Handling

The manager propagates errors from underlying layers:

```swift
do {
    let events = try await manager.fetchEventsWithCache()
} catch GraphQLError.noData {
    print("No data received from GraphQL query")
} catch GraphQLError.networkError(let underlyingError) {
    print("Network error: \(underlyingError)")
} catch {
    print("Unexpected error: \(error)")
}
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 6.1+
- Dependencies: api, models, storage packages 