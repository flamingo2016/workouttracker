import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var showingAddCustom = false
    @State private var customName = ""

    var grouped: [(MuscleGroup, [Exercise])] {
        let filtered = exercises.filter { ex in
            searchText.isEmpty || ex.name.localizedCaseInsensitiveContains(searchText)
        }
        let groups = Dictionary(grouping: filtered, by: \.muscleGroup)
        return MuscleGroup.allCases.compactMap { muscle in
            guard let group = groups[muscle], !group.isEmpty else { return nil }
            return (muscle, group.sorted { $0.name < $1.name })
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(grouped, id: \.0) { muscle, exs in
                    Section(muscle.displayName) {
                        ForEach(exs) { exercise in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(exercise.name)
                                    Text(exercise.category.displayName)
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                if exercise.isCustom {
                                    Text("Custom")
                                        .font(.caption2)
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(.blue.opacity(0.1))
                                        .foregroundStyle(.blue)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .onDelete { offsets in
                            for i in offsets where exs[i].isCustom {
                                modelContext.delete(exs[i])
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search exercises")
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAddCustom = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Custom Exercise", isPresented: $showingAddCustom) {
                TextField("Exercise name", text: $customName)
                Button("Add") {
                    guard !customName.isEmpty else { return }
                    let ex = Exercise(name: customName, category: .strength, muscleGroup: .fullBody, isCustom: true)
                    modelContext.insert(ex)
                    customName = ""
                }
                Button("Cancel", role: .cancel) { customName = "" }
            }
        }
    }
}
