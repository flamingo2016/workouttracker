import SwiftUI
import SwiftData

struct AddExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @State private var searchText = ""
    @State private var showingAddCustom = false
    @State private var customName = ""

    let onSelect: (Exercise) -> Void

    var filtered: [Exercise] {
        guard !searchText.isEmpty else { return exercises }
        return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { exercise in
                Button {
                    onSelect(exercise)
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(exercise.name).foregroundStyle(.primary)
                        Text("\(exercise.muscleGroup.displayName) · \(exercise.category.displayName)")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search exercises")
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Custom") { showingAddCustom = true }
                }
            }
            .alert("Custom Exercise", isPresented: $showingAddCustom) {
                TextField("Exercise name", text: $customName)
                Button("Add") {
                    guard !customName.isEmpty else { return }
                    let ex = Exercise(name: customName, category: .strength, muscleGroup: .fullBody, isCustom: true)
                    modelContext.insert(ex)
                    onSelect(ex)
                    customName = ""
                    dismiss()
                }
                Button("Cancel", role: .cancel) { customName = "" }
            }
        }
    }
}
