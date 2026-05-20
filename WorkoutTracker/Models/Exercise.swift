import SwiftData
import Foundation

enum MuscleGroup: String, Codable, CaseIterable {
    case chest, back, shoulders, arms, core, legs, glutes, fullBody

    var displayName: String {
        switch self {
        case .fullBody: return "Full Body"
        default: return rawValue.capitalized
        }
    }
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case strength, cardio, flexibility, bodyweight
    var displayName: String { rawValue.capitalized }
}

@Model
final class Exercise {
    var name: String
    var category: ExerciseCategory
    var muscleGroup: MuscleGroup
    var isCustom: Bool

    @Relationship(deleteRule: .nullify)
    var entries: [WorkoutEntry] = []

    init(name: String, category: ExerciseCategory, muscleGroup: MuscleGroup, isCustom: Bool = false) {
        self.name = name
        self.category = category
        self.muscleGroup = muscleGroup
        self.isCustom = isCustom
    }
}
