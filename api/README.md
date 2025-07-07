# Hub Community API Package

This package provides a GraphQL client for the Hub Community API using Apollo iOS.

## Features

- ✅ GraphQL client using Apollo iOS
- ✅ Protocol-based architecture for testability
- ✅ Mock client for unit testing
- ✅ Service layer with dependency injection
- ✅ Comprehensive error handling
- ✅ Type-safe models

## Installation

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(path: "path/to/api")
]
```

## Usage

### Basic Usage

```swift
import api

// Create a service instance
let eventsService = EventsService()

// Fetch events
do {
    let events = try await eventsService.getEvents()
    print("Found \(events.count) events")
} catch {
    print("Error fetching events: \(error)")
}
```

### Using the Factory

```swift
import api

// Create service with custom URL
let customURL = URL(string: "https://your-custom-endpoint.com/graphql")!
let eventsService = EventsServiceFactory.createService(baseURL: customURL)

// Fetch events
let events = try await eventsService.getEvents()
```

### Dependency Injection

```swift
import api

// Create a mock client for testing
let mockClient = MockGraphQLClient(mockEvents: [
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

// Inject the mock client into the service
let eventsService = EventsService(graphQLClient: mockClient)
```

## Testing

### Unit Tests

The package includes comprehensive unit tests. Run them with:

```bash
swift test
```

### Mock Client for Testing

```swift
import api

class YourViewControllerTests: XCTestCase {
    func testFetchEvents() async throws {
        // Given
        let mockEvents = [/* your mock events */]
        let mockService = EventsServiceFactory.createMockService(mockEvents: mockEvents)
        
        // When
        let events = try await mockService.getEvents()
        
        // Then
        XCTAssertEqual(events.count, mockEvents.count)
    }
    
    func testFetchEventsError() async {
        // Given
        let mockService = EventsServiceFactory.createMockService(
            shouldThrowError: true,
            mockError: GraphQLError.noData
        )
        
        // When & Then
        do {
            _ = try await mockService.getEvents()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GraphQLError, GraphQLError.noData)
        }
    }
}
```

## API Endpoint

The default GraphQL endpoint is:
```
https://hubcommunity-bff.8020digital.com.br/graphql
```

## GraphQL Schema

The package includes the following GraphQL query:

```graphql
query Events {
  events {
    data {
      id
      title
      tags {
        value
        id
      }
      talks {
        title
      }
      location {
        title
      }
      images
      communities {
        members_quantity
        title
      }
    }
  }
}
```

## Models

The package uses the following data models:

- `Event`: Main event model with all properties
- `Tag`: Event tags
- `Talk`: Event talks
- `Location`: Event location
- `Community`: Event communities

All models conform to `Codable` and `Identifiable` protocols.

## Error Handling

The package provides custom error types:

- `GraphQLError.noData`: When no data is received from the query
- `GraphQLError.networkError(Error)`: When a network error occurs

## Architecture

The package follows a clean architecture pattern:

1. **GraphQLClient**: Low-level Apollo client wrapper
2. **EventsService**: Business logic layer
3. **Protocols**: For dependency injection and testability
4. **Models**: Data structures from the models package

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 6.1+
- Apollo iOS 1.0.0+

## Communities Service

```swift
import api

// Create a service
let communitiesService = CommunitiesServiceFactory.createService()

// Fetch communities
do {
    let communities = try await communitiesService.getCommunities()
    print("Found \(communities.count) communities")
    
    for community in communities {
        print("Community: \(community.title ?? "Unknown")")
        print("Members: \(community.membersQuantity ?? 0)")
        print("Description: \(community.shortDescription ?? "No description")")
        print("Tags: \(community.tags?.map { $0.value ?? "" }.joined(separator: ", ") ?? "No tags")")
    }
} catch {
    print("Error fetching communities: \(error)")
}
```

### Testing

```swift
// Create a mock service for testing
let mockCommunities = [
    CommunityDto(
        id: "1",
        title: "Test Community",
        images: ["image1.jpg"],
        membersQuantity: 100,
        shortDescription: "Test Description",
        tags: [TagDto(id: "1", value: "Swift")]
    )
]

let mockService = CommunitiesServiceFactory.createMockService(mockCommunities: mockCommunities)
```

## GraphQL Queries

### Events Query
```graphql
query Events {
  events {
    data {
      id
      title
      tags {
        value
        id
      }
      talks {
        id
        title
      }
      location {
        id
        title
      }
      images
      communities {
        id
        title
        members_quantity
      }
    }
  }
}
```

### Communities Query
```graphql
query Data {
  communities {
    data {
      id
      title
      images
      members_quantity
      short_description
      tags {
        id
        value
      }
    }
  }
}
``` 