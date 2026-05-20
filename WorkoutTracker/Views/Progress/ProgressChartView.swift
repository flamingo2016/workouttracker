import SwiftUI
import SwiftData
import Charts

struct ProgressChartView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @Query(sort: \WorkoutSession.date) private var sessions: [WorkoutSession]
    @State private var selectedExercise: Exercise?
    @State private var metric: ProgressMetric = .maxWeight

    enum ProgressMetric: String, CaseIterable {
        case maxWeight = "Max Weight"
        case totalVolume = "Volume"
        case totalReps = "Reps"
    }

    struct DataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }

    var exercisesWithHistory: [Exercise] {
        exercises.filter { !$0.entries.isEmpty }
    }

    var chartData: [DataPoint] {
        guard let exercise = selectedExercise else { return [] }
        return sessions.compactMap { session in
            let relevant = session.entries.filter { $0.exercise?.persistentModelID == exercise.persistentModelID }
            guard !relevant.isEmpty else { return nil }
            let sets = relevant.flatMap(\.sets)
            let value: Double
            switch metric {
            case .maxWeight:   value = sets.map(\.weight).max() ?? 0
            case .totalVolume: value = sets.reduce(0) { $0 + $1.weight * Double($1.reps) }
            case .totalReps:   value = Double(sets.reduce(0) { $0 + $1.reps })
            }
            return DataPoint(date: session.date, value: value)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if exercisesWithHistory.isEmpty {
                    ContentUnavailableView(
                        "No Data Yet",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Log workouts to see your progress.")
                    )
                } else {
                    VStack(spacing: 0) {
                        Picker("Exercise", selection: $selectedExercise) {
                            Text("Select…").tag(Optional<Exercise>.none)
                            ForEach(exercisesWithHistory) { ex in
                                Text(ex.name).tag(Optional(ex))
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()

                        Picker("Metric", selection: $metric) {
                            ForEach(ProgressMetric.allCases, id: \.self) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)

                        if chartData.isEmpty {
                            ContentUnavailableView("No Data", systemImage: "chart.bar")
                                .frame(maxHeight: .infinity)
                        } else {
                            Chart(chartData) { point in
                                LineMark(
                                    x: .value("Date", point.date),
                                    y: .value(metric.rawValue, point.value)
                                )
                                .interpolationMethod(.catmullRom)
                                PointMark(
                                    x: .value("Date", point.date),
                                    y: .value(metric.rawValue, point.value)
                                )
                            }
                            .padding()
                            .frame(maxHeight: .infinity)
                        }
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}
