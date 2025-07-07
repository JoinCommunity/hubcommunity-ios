import Foundation
import manager
import models

@MainActor
public class EventsListViewModel: ObservableObject {
    @Published public private(set) var events: [Event] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil
    @Published public var isFirstLoading: Bool = true

    private let manager: EventsManagerProtocol

    public init(manager: EventsManagerProtocol = EventsManager()) {
        self.manager = manager
    }

    public func loadEvents() async {
        guard isFirstLoading else {
            return
        }

        isLoading = true
        errorMessage = nil
        do {
            events = try await manager.fetchEvents()
            // events = try await manager.refreshEvents()
            isFirstLoading = false
        } catch {
            isFirstLoading = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
