//
//  Tag.swift
//  models
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

public struct Tag: Codable, Identifiable, Sendable {
    public let id: String
    public let value: String
    
    public init(id: String, value: String) {
        self.id = id
        self.value = value
    }
} 