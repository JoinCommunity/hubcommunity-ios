import XCTest
@testable import manager
import models

final class EventsBusinessLogicTests: XCTestCase {
    
    private var testEvents: [Event]!
    
    override func setUp() {
        super.setUp()
        testEvents = [
            Event(
                id: "1",
                title: "Swift Conference",
                tags: [Tag(id: "1", value: "Swift"), Tag(id: "2", value: "iOS")],
                talks: [Talk(id: "1", title: "SwiftUI Basics")],
                location: Location(id: "1", title: "San Francisco"),
                images: ["swift-conf.jpg"],
                communities: [Community(id: "1", title: "Swift Developers", membersQuantity: 1000)]
            ),
            Event(
                id: "2",
                title: "Android Summit",
                tags: [Tag(id: "3", value: "Android"), Tag(id: "4", value: "Kotlin")],
                talks: [],
                location: Location(id: "2", title: "New York"),
                images: [],
                communities: [Community(id: "2", title: "Android Developers", membersQuantity: 500)]
            ),
            Event(
                id: "3",
                title: "Web Development Workshop",
                tags: [Tag(id: "5", value: "JavaScript"), Tag(id: "6", value: "React")],
                talks: [Talk(id: "2", title: "React Hooks"), Talk(id: "3", title: "TypeScript")],
                location: Location(id: "3", title: "Los Angeles"),
                images: ["web-workshop.jpg", "react.jpg"],
                communities: [Community(id: "3", title: "Web Developers", membersQuantity: 800), Community(id: "4", title: "React Community", membersQuantity: 1200)]
            )
        ]
    }
    
    // MARK: - Filtering Tests
    
    func testFilterEventsBySearchTerm() {
        // Given
        let filterOptions = EventFilterOptions(searchTerm: "Swift")
        
        // When
        let filteredEvents = EventsBusinessLogic.filterEvents(testEvents, with: filterOptions)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents.first?.title, "Swift Conference")
    }
    
    func testFilterEventsByTags() {
        // Given
        let filterOptions = EventFilterOptions(tags: ["JavaScript"])
        
        // When
        let filteredEvents = EventsBusinessLogic.filterEvents(testEvents, with: filterOptions)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents.first?.title, "Web Development Workshop")
    }
    
    func testFilterEventsByCommunities() {
        // Given
        let filterOptions = EventFilterOptions(communities: ["React Community"])
        
        // When
        let filteredEvents = EventsBusinessLogic.filterEvents(testEvents, with: filterOptions)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents.first?.title, "Web Development Workshop")
    }
    
    func testFilterEventsByHasTalks() {
        // Given
        let filterOptions = EventFilterOptions(hasTalks: true)
        
        // When
        let filteredEvents = EventsBusinessLogic.filterEvents(testEvents, with: filterOptions)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 2)
        XCTAssertTrue(filteredEvents.contains { $0.title == "Swift Conference" })
        XCTAssertTrue(filteredEvents.contains { $0.title == "Web Development Workshop" })
    }
    
    func testFilterEventsByHasImages() {
        // Given
        let filterOptions = EventFilterOptions(hasImages: true)
        
        // When
        let filteredEvents = EventsBusinessLogic.filterEvents(testEvents, with: filterOptions)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 2)
        XCTAssertTrue(filteredEvents.contains { $0.title == "Swift Conference" })
        XCTAssertTrue(filteredEvents.contains { $0.title == "Web Development Workshop" })
    }
    
    // MARK: - Sorting Tests
    
    func testSortEventsByTitleAscending() {
        // When
        let sortedEvents = EventsBusinessLogic.sortEvents(testEvents, by: .titleAscending)
        
        // Then
        XCTAssertEqual(sortedEvents[0].title, "Android Summit")
        XCTAssertEqual(sortedEvents[1].title, "Swift Conference")
        XCTAssertEqual(sortedEvents[2].title, "Web Development Workshop")
    }
    
    func testSortEventsByTitleDescending() {
        // When
        let sortedEvents = EventsBusinessLogic.sortEvents(testEvents, by: .titleDescending)
        
        // Then
        XCTAssertEqual(sortedEvents[0].title, "Web Development Workshop")
        XCTAssertEqual(sortedEvents[1].title, "Swift Conference")
        XCTAssertEqual(sortedEvents[2].title, "Android Summit")
    }
    
    func testSortEventsByCommunityCountDescending() {
        // When
        let sortedEvents = EventsBusinessLogic.sortEvents(testEvents, by: .communityCountDescending)
        
        // Then
        XCTAssertEqual(sortedEvents[0].title, "Web Development Workshop") // 2 communities
        XCTAssertEqual(sortedEvents[1].title, "Swift Conference") // 1 community
        XCTAssertEqual(sortedEvents[2].title, "Android Summit") // 1 community
    }
    
    func testSortEventsByTalkCountDescending() {
        // When
        let sortedEvents = EventsBusinessLogic.sortEvents(testEvents, by: .talkCountDescending)
        
        // Then
        XCTAssertEqual(sortedEvents[0].title, "Web Development Workshop") // 2 talks
        XCTAssertEqual(sortedEvents[1].title, "Swift Conference") // 1 talk
        XCTAssertEqual(sortedEvents[2].title, "Android Summit") // 0 talks
    }
    
    // MARK: - Analytics Tests
    
    func testGetUniqueTags() {
        // When
        let uniqueTags = EventsBusinessLogic.getUniqueTags(from: testEvents)
        
        // Then
        XCTAssertEqual(uniqueTags.count, 6)
        let tagValues = uniqueTags.map { $0.value }
        XCTAssertTrue(tagValues.contains("Swift"))
        XCTAssertTrue(tagValues.contains("iOS"))
        XCTAssertTrue(tagValues.contains("Android"))
        XCTAssertTrue(tagValues.contains("Kotlin"))
        XCTAssertTrue(tagValues.contains("JavaScript"))
        XCTAssertTrue(tagValues.contains("React"))
    }
    
    func testGetUniqueCommunities() {
        // When
        let uniqueCommunities = EventsBusinessLogic.getUniqueCommunities(from: testEvents)
        
        // Then
        XCTAssertEqual(uniqueCommunities.count, 4)
        let communityTitles = uniqueCommunities.map { $0.title }
        XCTAssertTrue(communityTitles.contains("Swift Developers"))
        XCTAssertTrue(communityTitles.contains("Android Developers"))
        XCTAssertTrue(communityTitles.contains("Web Developers"))
        XCTAssertTrue(communityTitles.contains("React Community"))
    }
    
    func testGetEventsStatistics() {
        // When
        let statistics = EventsBusinessLogic.getEventsStatistics(from: testEvents)
        
        // Then
        XCTAssertEqual(statistics.totalEvents, 3)
        XCTAssertEqual(statistics.totalTalks, 3)
        XCTAssertEqual(statistics.totalCommunities, 4)
        XCTAssertEqual(statistics.eventsWithImages, 2)
        XCTAssertEqual(statistics.eventsWithTalks, 2)
        XCTAssertEqual(statistics.averageTalksPerEvent, 1.0, accuracy: 0.01)
        XCTAssertEqual(statistics.averageCommunitiesPerEvent, 1.33, accuracy: 0.01)
        XCTAssertEqual(statistics.eventsWithImagesPercentage, 66.67, accuracy: 0.01)
        XCTAssertEqual(statistics.eventsWithTalksPercentage, 66.67, accuracy: 0.01)
    }
} 