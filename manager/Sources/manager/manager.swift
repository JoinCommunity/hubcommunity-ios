// The Swift Programming Language
// https://docs.swift.org/swift-book

// MARK: - Public API Exports
@_exported import api
@_exported import models
@_exported import storage

// Re-export main components for easy access
public typealias EventsManagerAPI = EventsManager
public typealias EnhancedEventsManagerAPI = EnhancedEventsManager
public typealias EventsManagerFactoryAPI = EventsManagerFactory
public typealias EnhancedEventsManagerFactoryAPI = EnhancedEventsManagerFactory
