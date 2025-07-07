import api
@testable import manager
import models
import XCTest

final class EventsMapperTests: XCTestCase {

    // MARK: - Tag Mapper Tests

    func testTagMapperWithValidDto() {
        // Given
        let tagDto = TagDto(id: "1", value: "Swift")

        // When
        let result = TagMapper.map(tagDto)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "1")
        XCTAssertEqual(result?.value, "Swift")
    }

    func testTagMapperWithNilDto() {
        // Given
        let tagDto: TagDto? = nil

        // When
        let result = TagMapper.map(tagDto)

        // Then
        XCTAssertNil(result)
    }

    func testTagMapperWithInvalidDto() {
        // Given
        let tagDto = TagDto(id: nil, value: "Swift")

        // When
        let result = TagMapper.map(tagDto)

        // Then
        XCTAssertNil(result)
    }

    func testTagMapperArrayWithValidDtos() {
        // Given
        let tagDtos = [
            TagDto(id: "1", value: "Swift"),
            TagDto(id: "2", value: "iOS")
        ]

        // When
        let result = TagMapper.map(tagDtos)

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].value, "Swift")
        XCTAssertEqual(result[1].id, "2")
        XCTAssertEqual(result[1].value, "iOS")
    }

    func testTagMapperArrayWithNilArray() {
        // Given
        let tagDtos: [TagDto]? = nil

        // When
        let result = TagMapper.map(tagDtos)

        // Then
        XCTAssertEqual(result.count, 0)
    }

    // MARK: - Talk Mapper Tests

    func testTalkMapperWithValidDto() {
        // Given
        let talkDto = TalkDto(id: "1", title: "Introduction to Swift")

        // When
        let result = TalkMapper.map(talkDto)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "1")
        XCTAssertEqual(result?.title, "Introduction to Swift")
    }

    func testTalkMapperWithNilDto() {
        // Given
        let talkDto: TalkDto? = nil

        // When
        let result = TalkMapper.map(talkDto)

        // Then
        XCTAssertNil(result)
    }

    func testTalkMapperArrayWithValidDtos() {
        // Given
        let talkDtos = [
            TalkDto(id: "1", title: "Talk 1"),
            TalkDto(id: "2", title: "Talk 2")
        ]

        // When
        let result = TalkMapper.map(talkDtos)

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Talk 1")
        XCTAssertEqual(result[1].id, "2")
        XCTAssertEqual(result[1].title, "Talk 2")
    }

    // MARK: - Location Mapper Tests

    func testLocationMapperWithValidDto() {
        // Given
        let locationDto = LocationDto(id: "1", title: "San Francisco")

        // When
        let result = LocationMapper.map(locationDto)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "1")
        XCTAssertEqual(result?.title, "San Francisco")
    }

    func testLocationMapperWithNilDto() {
        // Given
        let locationDto: LocationDto? = nil

        // When
        let result = LocationMapper.map(locationDto)

        // Then
        XCTAssertNil(result)
    }

    // MARK: - Community Mapper Tests

    func testCommunityMapperWithValidDto() {
        // Given
        let communityDto = CommunityDto(
            id: "1",
            title: "iOS Developers",
            images: nil,
            membersQuantity: 150,
            shortDescription: nil,
            tags: nil
        )

        // When
        let result = CommunityMapper.map(communityDto)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "1")
        XCTAssertEqual(result?.title, "iOS Developers")
        XCTAssertEqual(result?.membersQuantity, 150)
    }

    func testCommunityMapperWithNilDto() {
        // Given
        let communityDto: CommunityDto? = nil

        // When
        let result = CommunityMapper.map(communityDto)

        // Then
        XCTAssertNil(result)
    }

    func testCommunityMapperArrayWithValidDtos() {
        // Given
        let communityDtos = [
            CommunityDto(
                id: "1",
                title: "Community 1",
                images: nil,
                membersQuantity: 100,
                shortDescription: nil,
                tags: nil
            ),
            CommunityDto(
                id: "2",
                title: "Community 2",
                images: nil,
                membersQuantity: 200,
                shortDescription: nil,
                tags: nil
            )
        ]

        // When
        let result = CommunityMapper.map(communityDtos)

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Community 1")
        XCTAssertEqual(result[0].membersQuantity, 100)
        XCTAssertEqual(result[1].id, "2")
        XCTAssertEqual(result[1].title, "Community 2")
        XCTAssertEqual(result[1].membersQuantity, 200)
    }

    // MARK: - Events Mapper Tests

    func testEventsMapperWithValidDto() {
        // Given
        let eventDto = EventDto(
            id: "1",
            title: "WWDC 2024",
            tags: [TagDto(id: "1", value: "iOS")],
            talks: [TalkDto(id: "1", title: "Keynote")],
            location: LocationDto(id: "1", title: "San Jose"),
            images: ["image1.jpg", "image2.jpg"],
            communities: [CommunityDto(
                id: "1",
                title: "Apple Developers",
                images: nil,
                membersQuantity: 1000,
                shortDescription: nil,
                tags: nil
            )]
        )

        // When
        let result = EventsMapper.map(eventDto)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "1")
        XCTAssertEqual(result?.title, "WWDC 2024")
        XCTAssertEqual(result?.tags.count, 1)
        XCTAssertEqual(result?.talks.count, 1)
        XCTAssertEqual(result?.location.id, "1")
        XCTAssertEqual(result?.images.count, 2)
        XCTAssertEqual(result?.communities.count, 1)
    }

    func testEventsMapperWithNilDto() {
        // Given
        let eventDto: EventDto? = nil

        // When
        let result = EventsMapper.map(eventDto)

        // Then
        XCTAssertNil(result)
    }

    func testEventsMapperWithInvalidDto() {
        // Given
        let eventDto = EventDto(
            id: nil,
            title: "WWDC 2024",
            tags: nil,
            talks: nil,
            location: nil,
            images: nil,
            communities: nil
        )

        // When
        let result = EventsMapper.map(eventDto)

        // Then
        XCTAssertNil(result)
    }

    func testEventsMapperArrayWithValidDtos() {
        // Given
        let eventDtos = [
            EventDto(
                id: "1",
                title: "Event 1",
                tags: nil,
                talks: nil,
                location: LocationDto(id: "1", title: "Location 1"),
                images: nil,
                communities: nil
            ),
            EventDto(
                id: "2",
                title: "Event 2",
                tags: nil,
                talks: nil,
                location: LocationDto(id: "2", title: "Location 2"),
                images: nil,
                communities: nil
            )
        ]

        // When
        let result = EventsMapper.map(eventDtos)

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "1")
        XCTAssertEqual(result[0].title, "Event 1")
        XCTAssertEqual(result[1].id, "2")
        XCTAssertEqual(result[1].title, "Event 2")
    }

    func testEventsMapperArrayWithNilArray() {
        // Given
        let eventDtos: [EventDto]? = nil

        // When
        let result = EventsMapper.map(eventDtos)

        // Then
        XCTAssertEqual(result.count, 0)
    }

    // MARK: - EventsResponse Mapper Tests

    func testEventsResponseMapperWithValidDto() {
        // Given
        let eventsDto = EventsDto(data: [
            EventDto(
                id: "1",
                title: "Event 1",
                tags: nil,
                talks: nil,
                location: LocationDto(id: "1", title: "Location 1"),
                images: nil,
                communities: nil
            )
        ])

        // When
        let result = EventsMapper.map(eventsDto)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data.count, 1)
        XCTAssertEqual(result?.data[0].id, "1")
        XCTAssertEqual(result?.data[0].title, "Event 1")
    }

    func testEventsResponseMapperWithNilDto() {
        // Given
        let eventsDto: EventsDto? = nil

        // When
        let result = EventsMapper.map(eventsDto)

        // Then
        XCTAssertNil(result)
    }
}
