//
//  Talk.swift
//  models
//
//  Created by Zé Net on 06/07/2025.
//

import Foundation

public struct Talk: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
} 