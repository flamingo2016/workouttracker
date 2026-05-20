import SwiftUI

struct WorkoutDetailView: View {
    let session: WorkoutSession

    var sortedEntries: [WorkoutEntry] {
        session.entries.sorted { $0.orderIndex < $1.orderIndex }
    }

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Date", value: session.date.formatted(date: .long, time: .omitted))
                LabeledContent("Exercises", value: "\(session.entries.count)")
                LabeledContent("Total Sets", value: "\(session.totalSets)")
                LabeledContent("Total Volume", value: String(format: "%.1f kg", session.totalVolume))
            }
            ForEach(sortedEntries) { entry in
                Section(entry.exercise?.name ?? "Exercise") {
                    let sorted = entry.sets.sorted { $0.orderIndex < $1.orderIndex }
                    ForEach(Array(sorted.enumerated()), id: \.element.persistentModelID) { i, set in
                        HStack {
                            Text("Set \(i + 1)").foregroundStyle(.secondary)
                            Spacer()
                            Text("\(set.weight, format: .number) kg × \(set.reps) reps")
                        }
                    }
                }
            }
        }
        .navigationTitle(session.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
