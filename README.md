# Hub Community

A modern iOS app built with SwiftUI that connects developers with tech events and communities. The app provides a seamless experience for discovering events, exploring communities, and staying connected with the developer ecosystem.

## 🏗️ Architecture

The app follows a modular architecture with clear separation of concerns across multiple Swift packages:

### 📱 UI Layer (`Hub Community/`)
- **SwiftUI Views**: Modern, declarative UI components
- **ViewModels**: Observable objects that manage view state and business logic
- **TabView Navigation**: Clean tab-based navigation between Events and Communities
- **Environment Objects**: Shared state management across views

**Key Components:**
- `EventsListView`: Displays events with location, tags, and community information
- `CommunitiesListView`: Shows communities with member counts
- `EventsListViewModel`: Manages events data, loading states, and error handling
- `CommunitiesListViewModel`: Handles communities data and UI state

### 🔧 Manager Layer (`manager/`)
- **Business Logic**: Coordinates between UI and data layers
- **Caching Strategy**: Implements cache-first approach for better performance
- **Data Mapping**: Converts between API DTOs and domain models

**Key Components:**
- `EventsManager`: Handles events data operations with caching
- `CommunitiesManager`: Manages communities data with cache-first strategy
- **Mappers**: Convert between API DTOs and domain models
  - `EventsMapper`
  - `CommunityMapper`
  - `LocationMapper`
  - `TagMapper`
  - `TalkMapper`

### 💾 Storage Layer (`storage/`)
- **Data Persistence**: Local storage for offline access
- **Cache Management**: Efficient caching strategies for better UX
- **Storage Service**: Abstract interface for storage operations

**Key Components:**
- `StorageService`: Protocol-based storage interface
- `storage.swift`: Core storage implementation

### 🌐 API Layer (`api/`)
- **GraphQL Integration**: Modern API communication using GraphQL
- **Network Layer**: Robust HTTP client with error handling
- **Service Layer**: Clean service abstractions for API operations

**Key Components:**
- **GraphQL Client**: `GraphQLClient.swift` for API communication
- **Error Handling**: `GraphQLError.swift` for consistent error management
- **Request Management**: `GraphQLRequest.swift` for request formatting
- **Services**:
  - `EventsService`: Events API operations
  - `CommunitiesService`: Communities API operations
  - **DTOs**: Data Transfer Objects for API communication

### 📦 Models (`models/`)
- **Domain Models**: Core business entities
- **Codable Support**: JSON serialization/deserialization
- **Identifiable**: SwiftUI list compatibility

**Key Models:**
- `Event`: Event information with location, tags, and talks
- `Community`: Community details with member counts
- `Location`: Geographic information
- `Tag`: Event categorization
- `Talk`: Event presentation details

## 🚀 Features

- **Events Discovery**: Browse tech events with detailed information
- **Community Exploration**: Discover developer communities
- **Offline Support**: Cached data for offline viewing
- **Modern UI**: SwiftUI-based interface with smooth animations
- **Error Handling**: Graceful error states with retry functionality
- **Loading States**: Smooth loading experiences

## 🛠️ Development

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Setup
1. Clone the repository
2. Open `Hub Community.xcodeproj` in Xcode
3. Build and run the project

### Project Structure
```
Hub Community/
├── api/                    # API layer with GraphQL integration
├── manager/               # Business logic and data coordination
├── models/                # Domain models and data structures
├── storage/               # Local storage and caching
├── Hub Community/         # Main iOS app with SwiftUI views
└── Tests/                 # Unit tests for each layer
```

## 🧪 Testing

The project includes comprehensive unit tests for each layer:
- **API Tests**: GraphQL service testing
- **Manager Tests**: Business logic validation
- **Model Tests**: Data structure verification
- **Storage Tests**: Persistence layer testing

## 📋 TODO

### Storage Improvements
- [ ] **Replace UserDefaults with Core Data**
  - Implement Core Data model for events and communities
  - Add data migration strategy for existing UserDefaults data
  - Create Core Data stack with proper error handling

- [ ] **Add SQLite Database Support**
  - Implement SQLite wrapper for better performance
  - Add database versioning and migration support
  - Create database indexes for faster queries

- [ ] **Implement CloudKit Sync**
  - Add CloudKit integration for cross-device sync
  - Handle conflict resolution for offline changes
  - Implement background sync capabilities

- [ ] **Add Data Encryption**
  - Encrypt sensitive data at rest
  - Implement secure key management
  - Add biometric authentication for sensitive operations

- [ ] **Optimize Cache Strategy**
  - Implement LRU cache eviction policy
  - Add cache size limits and cleanup
  - Create cache warming strategies for better UX

- [ ] **Add Data Backup/Restore**
  - Implement data export functionality
  - Add backup to iCloud Drive
  - Create data recovery mechanisms

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Links

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [GraphQL Documentation](https://graphql.org/learn/)
- [Core Data Documentation](https://developer.apple.com/documentation/coredata) 