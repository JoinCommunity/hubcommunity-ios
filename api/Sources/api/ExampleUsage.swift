import Foundation
import models

// MARK: - Example Usage
// This file demonstrates how to use the GraphQL API package

public class ExampleUsage {
    
    // MARK: - Basic Usage Example
    public static func basicUsage() async {
        let eventsService = EventsService()
        
        do {
            let events = try await eventsService.getEvents()
            print("✅ Successfully fetched \(events.count) events")
            
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
    
    // MARK: - Custom URL Example
    public static func customURLUsage() async {
        let customURL = URL(string: "https://your-custom-endpoint.com/graphql")!
        let eventsService = EventsServiceFactory.createService(baseURL: customURL)
        
        do {
            let events = try await eventsService.getEvents()
            print("✅ Successfully fetched \(events.count) events from custom endpoint")
        } catch {
            print("❌ Error fetching events: \(error)")
        }
    }
    
    // MARK: - Error Handling Example
    public static func errorHandlingExample() async {
        let eventsService = EventsService()
        
        do {
            let events = try await eventsService.getEvents()
            print("✅ Success: \(events.count) events")
        } catch GraphQLError.noData {
            print("❌ No data received from GraphQL query")
        } catch GraphQLError.networkError(let underlyingError) {
            print("❌ Network error: \(underlyingError)")
        } catch {
            print("❌ Unexpected error: \(error)")
        }
    }
    
    // MARK: - Testing Example
    public static func testingExample() async {
        // Create mock data for testing
        let mockEvents = [
            Event(
                id: "1",
                title: "Swift Conference 2024",
                tags: [
                    Tag(id: "1", value: "Swift"),
                    Tag(id: "2", value: "iOS")
                ],
                talks: [
                    Talk(id: "1", title: "Advanced Swift Patterns"),
                    Talk(id: "2", title: "SwiftUI Best Practices")
                ],
                location: Location(id: "1", title: "San Francisco Convention Center"),
                images: ["swift-conf-1.jpg", "swift-conf-2.jpg"],
                communities: [
                    Community(id: "1", title: "Swift Developers", membersQuantity: 5000),
                    Community(id: "2", title: "iOS Engineers", membersQuantity: 3000)
                ]
            ),
            Event(
                id: "2",
                title: "Mobile Development Summit",
                tags: [
                    Tag(id: "3", value: "Mobile"),
                    Tag(id: "4", value: "Development")
                ],
                talks: [
                    Talk(id: "3", title: "Cross-Platform Development")
                ],
                location: Location(id: "2", title: "Tech Hub Downtown"),
                images: ["mobile-summit.jpg"],
                communities: [
                    Community(id: "3", title: "Mobile Developers", membersQuantity: 2000)
                ]
            )
        ]
        
        // Create mock service for testing
        let mockService = EventsServiceFactory.createMockService(mockEvents: mockEvents)
        
        do {
            let events = try await mockService.getEvents()
            print("✅ Mock test successful: \(events.count) events")
            
            // Verify the mock data
            if events.count == 2 {
                print("✅ Correct number of events")
            }
            if events.first?.title == "Swift Conference 2024" {
                print("✅ First event title is correct")
            }
            if events.last?.title == "Mobile Development Summit" {
                print("✅ Last event title is correct")
            }
            
        } catch {
            print("❌ Mock test failed: \(error)")
        }
    }
    
    // MARK: - Error Testing Example
    public static func errorTestingExample() async {
        let mockService = EventsServiceFactory.createMockService(
            shouldThrowError: true,
            mockError: GraphQLError.noData
        )
        
        do {
            _ = try await mockService.getEvents()
            print("❌ Expected error was not thrown")
        } catch GraphQLError.noData {
            print("✅ Error testing successful: NoData error caught")
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
    
    private let eventsService: EventsServiceProtocol
    
    public init(eventsService: EventsServiceProtocol = EventsService()) {
        self.eventsService = eventsService
    }
    
    public func loadEvents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            events = try await eventsService.getEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: - SwiftUI View Example
#if canImport(SwiftUI)
import SwiftUI

public struct EventsView: View {
    @StateObject private var viewModel = EventsViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading events...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.loadEvents()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List(viewModel.events) { event in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.title)
                                .font(.headline)
                            
                            Text(event.location.title)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if !event.tags.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(event.tags) { tag in
                                            Text(tag.value)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            
                            HStack {
                                Label("\(event.talks.count) talks", systemImage: "mic")
                                Spacer()
                                Label("\(event.communities.count) communities", systemImage: "person.3")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Events")
            .task {
                await viewModel.loadEvents()
            }
        }
    }
}
#endif 