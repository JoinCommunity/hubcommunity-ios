@testable import api
import models
import XCTest

final class GraphQLClientTests: XCTestCase {

    func testMockClientReturnsMockEvents() async throws {
        // Given
        let mockEvents = [
            Event(
                id: "1",
                title: "Test Event",
                tags: [Tag(id: "1", value: "Swift")],
                talks: [Talk(id: "1", title: "Test Talk")],
                location: Location(id: "1", title: "Test Location"),
                images: ["image1.jpg"],
                communities: [Community(id: "1", title: "Test Community", membersQuantity: 100)]
            )
        ]

        let mockClient = MockGraphQLClient(mockEvents: mockEvents)

        // When
        let result = try await mockClient.fetchEvents()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(result.first?.title, "Test Event")
    }

    func testMockClientThrowsError() async {
        // Given
        let mockError = GraphQLError.noData
        let mockClient = MockGraphQLClient(shouldThrowError: true, mockError: mockError)

        // When & Then
        do {
            _ = try await mockClient.fetchEvents()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GraphQLError, mockError)
        }
    }

    func testGraphQLErrorLocalizedDescription() {
        // Given
        let noDataError = GraphQLError.noData
        let networkError = GraphQLError.networkError(NSError(domain: "test", code: 0, userInfo: nil))

        // Then
        XCTAssertEqual(noDataError.errorDescription, "No data received from GraphQL query")
        XCTAssertTrue(networkError.errorDescription?.contains("Network error") == true)
    }
}
