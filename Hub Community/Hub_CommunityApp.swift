import SwiftUI

@main
struct Hub_CommunityApp: App {

    init() {
        loadRocketSimConnect()
    }

    private let eventsViewModel = EventsListViewModel()
    private let communitiesViewModel = CommunitiesListViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                EventsListView()
                    .environmentObject(eventsViewModel)
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }

                CommunitiesListView()
                    .environmentObject(communitiesViewModel)
                    .tabItem {
                        Label("Communities", systemImage: "person.3")
                    }
            }
        }
    }

    private func loadRocketSimConnect() {
        #if DEBUG
        guard Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true else {
            print("Failed to load linker framework")
            return
        }
        print("RocketSim Connect successfully linked")
        #endif
    }
}
