import SwiftUI
import SwiftData

struct LogWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var activeSession: WorkoutSession?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 80))
                    .foregroundStyle(.secondary)
                Text("Ready to train?")
                    .font(.title2)
                    .fontWeight(.semibold)
                Button {
                    let session = WorkoutSession()
                    modelContext.insert(session)
                    activeSession = session
                } label: {
                    Label("Start Workout", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("Log Workout")
            .sheet(item: $activeSession) { session in
                ActiveWorkoutView(session: session)
            }
        }
        .onAppear {
            SampleData.insertDefaultExercises(into: modelContext)
        }
    }
}
