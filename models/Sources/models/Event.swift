//
//  Event.swift
//  models
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

public struct Event: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let tags: [Tag]
    public let talks: [Talk]
    public let location: Location
    public let images: [String]
    public let communities: [Community]
    
    public init(
        id: String,
        title: String,
        tags: [Tag],
        talks: [Talk],
        location: Location,
        images: [String],
        communities: [Community]
    ) {
        self.id = id
        self.title = title
        self.tags = tags
        self.talks = talks
        self.location = location
        self.images = images
        self.communities = communities
    }
} 