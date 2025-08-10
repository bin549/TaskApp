import SwiftUI

@main
struct TaskApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
    }
}
