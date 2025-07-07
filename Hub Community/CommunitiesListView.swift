import models
import SwiftUI

struct CommunitiesListView: View {
    @EnvironmentObject private var viewModel: CommunitiesListViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading communities...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error loading communities")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.loadCommunities() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.communities) { community in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(community.title)
                                .font(.headline)
                            HStack {
                                Label("\(community.membersQuantity) members", systemImage: "person.3")
                                Spacer()
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Communities")
            .task {
                if viewModel.isFirstLoading {
                    await viewModel.loadCommunities()
                }
            }
        }
    }
}

#Preview {
    CommunitiesListView()
        .environmentObject(CommunitiesListViewModel())
}
