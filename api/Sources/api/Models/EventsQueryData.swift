//
//  EventsQueryData.swift
//  api
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

// MARK: - Events Query Data Models
struct EventsQueryData: Codable {
    let events: EventsData?
}

struct EventsData: Codable {
    let data: [EventData]?
}

struct EventData: Codable {
    let id: String?
    let title: String?
    let tags: [TagData]?
    let talks: [TalkData]?
    let location: LocationData?
    let images: [String]?
    let communities: [CommunityData]?
} 