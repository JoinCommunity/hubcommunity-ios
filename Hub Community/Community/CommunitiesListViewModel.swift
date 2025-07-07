import Foundation
import manager
import models

@MainActor
public class CommunitiesListViewModel: ObservableObject {
    @Published public private(set) var communities: [Community] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public var isFirstLoading: Bool = true
    @Published public private(set) var errorMessage: String? = nil

    private let manager: CommunitiesManagerProtocol

    public init(manager: CommunitiesManagerProtocol = CommunitiesManager()) {
        self.manager = manager
    }

    public func loadCommunities() async {
        guard isFirstLoading else {
            return
        }

        isLoading = true
        errorMessage = nil
        do {
            communities = try await manager.fetchCommunities()
            // communities = try await manager.refreshCommunities()
            isFirstLoading = false
        } catch {
            isFirstLoading = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
