@testable import api
import XCTest

final class CommunitiesServiceTests: XCTestCase {

    func testCommunitiesServiceReturnsCommunities() async throws {
        // Given
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

        let mockClient = MockGraphQLClient(mockCommunities: mockCommunities)
        let service = CommunitiesService(graphQLClient: mockClient)

        // When
        let result = try await service.getCommunities()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
        XCTAssertEqual(result.first?.title, "Test Community")
        XCTAssertEqual(result.first?.membersQuantity, 100)
        XCTAssertEqual(result.first?.shortDescription, "Test Description")
        XCTAssertEqual(result.first?.images?.count, 1)
        XCTAssertEqual(result.first?.tags?.count, 1)
    }

    func testCommunitiesServicePropagatesError() async {
        // Given
        let mockError = GraphQLError.noData
        let mockClient = MockGraphQLClient(shouldThrowError: true, mockError: mockError)
        let service = CommunitiesService(graphQLClient: mockClient)

        // When & Then
        do {
            _ = try await service.getCommunities()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GraphQLError, mockError)
        }
    }

    func testCommunitiesServiceFactoryCreatesService() {
        // Given
        let url = URL(string: "https://test.com/graphql")!

        // When
        let service = CommunitiesServiceFactory.createService(baseURL: url)

        // Then
        XCTAssertNotNil(service)
        XCTAssertTrue(service is CommunitiesService)
    }

    func testCommunitiesServiceFactoryCreatesMockService() {
        // Given
        let mockCommunities = [
            CommunityDto(
                id: "1",
                title: "Test Community",
                images: [],
                membersQuantity: 100,
                shortDescription: "Test",
                tags: []
            )
        ]

        // When
        let service = CommunitiesServiceFactory.createMockService(mockCommunities: mockCommunities)

        // Then
        XCTAssertNotNil(service)
        XCTAssertTrue(service is CommunitiesService)
    }

    func testCommunitiesServiceDefaultInitializer() {
        // When
        let service = CommunitiesService()

        // Then
        XCTAssertNotNil(service)
    }
}
