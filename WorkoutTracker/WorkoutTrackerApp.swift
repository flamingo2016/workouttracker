import SwiftUI
import SwiftData

@main
struct WorkoutTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Exercise.self, WorkoutSession.self, WorkoutEntry.self, WorkoutSet.self])
    }
}
