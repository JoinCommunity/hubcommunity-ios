import Foundation
import manager
import models

@MainActor
public class EventsListViewModel: ObservableObject {
    @Published public private(set) var events: [Event] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil

    private let manager: EnhancedEventsManagerProtocol

    public init(manager: EnhancedEventsManagerProtocol = EnhancedEventsManager()) {
        self.manager = manager
    }

    public func loadEvents() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await manager.fetchEventsWithCache()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
