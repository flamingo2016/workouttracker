import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var session: WorkoutSession
    @State private var showingExercisePicker = false

    var sortedEntries: [WorkoutEntry] {
        session.entries.sorted { $0.orderIndex < $1.orderIndex }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Workout name", text: $session.name)
                        .font(.headline)
                }
                ForEach(sortedEntries) { entry in
                    EntryRowView(entry: entry)
                }
                .onDelete { offsets in
                    let sorted = sortedEntries
                    for i in offsets { modelContext.delete(sorted[i]) }
                }
                Button {
                    showingExercisePicker = true
                } label: {
                    Label("Add Exercise", systemImage: "plus")
                }
            }
            .navigationTitle("Active Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Discard") {
                        modelContext.delete(session)
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Finish") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                AddExerciseSheet { exercise in
                    let entry = WorkoutEntry(exercise: exercise, orderIndex: session.entries.count)
                    entry.session = session
                    session.entries.append(entry)
                    modelContext.insert(entry)
                }
            }
        }
    }
}

struct EntryRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var entry: WorkoutEntry

    var sortedSets: [WorkoutSet] {
        entry.sets.sorted { $0.orderIndex < $1.orderIndex }
    }

    var body: some View {
        Section(entry.exercise?.name ?? "Exercise") {
            ForEach(Array(sortedSets.enumerated()), id: \.element.persistentModelID) { index, set in
                SetRowView(set: set, index: index + 1)
            }
            .onDelete { offsets in
                let sorted = sortedSets
                for i in offsets { modelContext.delete(sorted[i]) }
            }
            Button {
                let s = WorkoutSet(
                    reps: sortedSets.last?.reps ?? 10,
                    weight: sortedSets.last?.weight ?? 0,
                    orderIndex: entry.sets.count
                )
                s.entry = entry
                entry.sets.append(s)
                modelContext.insert(s)
            } label: {
                Label("Add Set", systemImage: "plus").font(.subheadline)
            }
        }
    }
}

struct SetRowView: View {
    @Bindable var set: WorkoutSet
    let index: Int

    var body: some View {
        HStack {
            Text("Set \(index)")
                .foregroundStyle(.secondary)
                .frame(width: 50, alignment: .leading)
            HStack {
                TextField("0", value: $set.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)
                Text("kg").foregroundStyle(.secondary).font(.caption)
            }
            Spacer()
            HStack {
                TextField("0", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
                Text("reps").foregroundStyle(.secondary).font(.caption)
            }
        }
    }
}
