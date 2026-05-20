import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LogWorkoutView()
                .tabItem { Label("Log", systemImage: "plus.circle.fill") }
            HistoryView()
                .tabItem { Label("History", systemImage: "clock.fill") }
            ProgressChartView()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
            ExerciseLibraryView()
                .tabItem { Label("Exercises", systemImage: "dumbbell.fill") }
        }
    }
}
