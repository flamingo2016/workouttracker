import SwiftData
import Foundation

struct SampleData {
    static let exercises: [(name: String, category: ExerciseCategory, muscle: MuscleGroup)] = [
        ("Bench Press", .strength, .chest),
        ("Incline Bench Press", .strength, .chest),
        ("Push-Up", .bodyweight, .chest),
        ("Cable Fly", .strength, .chest),
        ("Pull-Up", .bodyweight, .back),
        ("Barbell Row", .strength, .back),
        ("Lat Pulldown", .strength, .back),
        ("Cable Row", .strength, .back),
        ("Overhead Press", .strength, .shoulders),
        ("Lateral Raise", .strength, .shoulders),
        ("Front Raise", .strength, .shoulders),
        ("Barbell Curl", .strength, .arms),
        ("Tricep Pushdown", .strength, .arms),
        ("Hammer Curl", .strength, .arms),
        ("Skull Crusher", .strength, .arms),
        ("Squat", .strength, .legs),
        ("Deadlift", .strength, .legs),
        ("Leg Press", .strength, .legs),
        ("Romanian Deadlift", .strength, .legs),
        ("Leg Curl", .strength, .legs),
        ("Hip Thrust", .strength, .glutes),
        ("Glute Bridge", .bodyweight, .glutes),
        ("Plank", .bodyweight, .core),
        ("Crunch", .bodyweight, .core),
        ("Cable Crunch", .strength, .core),
        ("Clean and Press", .strength, .fullBody),
        ("Burpee", .bodyweight, .fullBody),
        ("Running", .cardio, .fullBody),
        ("Cycling", .cardio, .fullBody),
        ("Jump Rope", .cardio, .fullBody),
    ]

    @MainActor
    static func insertDefaultExercises(into context: ModelContext) {
        let descriptor = FetchDescriptor<Exercise>(predicate: #Predicate { !$0.isCustom })
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        for item in exercises {
            context.insert(Exercise(name: item.name, category: item.category, muscleGroup: item.muscle))
        }
    }
}
