//
//  EventsResponse.swift
//  models
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

public struct EventsResponse: Codable, Sendable {
    public let data: [Event]
    
    public init(data: [Event]) {
        self.data = data
    }
} 