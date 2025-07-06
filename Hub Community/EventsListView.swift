//
//  EventsListView.swift
//  Hub Commnity
//
//  Created by Zé Net on 06/07/2025.
//

import SwiftUI
import models

struct EventsListView: View {
    @StateObject private var viewModel = EventsListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading events...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error loading events")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.loadEvents() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.events) { event in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.location.title)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            if !event.tags.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(event.tags) { tag in
                                            Text(tag.value)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            HStack {
                                Label("\(event.talks.count) talks", systemImage: "mic")
                                Spacer()
                                Label("\(event.communities.count) communities", systemImage: "person.3")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Events")
            .task {
                await viewModel.loadEvents()
            }
        }
    }
}

#Preview {
    EventsListView()
} 