import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Group {
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No Workouts Yet",
                        systemImage: "clock",
                        description: Text("Your completed workouts will appear here.")
                    )
                } else {
                    List {
                        ForEach(sessions) { session in
                            NavigationLink(destination: WorkoutDetailView(session: session)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(session.name).font(.headline)
                                    HStack {
                                        Text(session.date.formatted(date: .abbreviated, time: .omitted))
                                        Text("·")
                                        Text("\(session.entries.count) exercise\(session.entries.count == 1 ? "" : "s")")
                                        Text("·")
                                        Text("\(session.totalSets) sets")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .onDelete { offsets in
                            for i in offsets { modelContext.delete(sessions[i]) }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}
