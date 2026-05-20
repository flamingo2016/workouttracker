import SwiftData

@Model
final class WorkoutEntry {
    var orderIndex: Int

    @Relationship(deleteRule: .nullify)
    var exercise: Exercise?

    var session: WorkoutSession?

    @Relationship(deleteRule: .cascade)
    var sets: [WorkoutSet] = []

    init(exercise: Exercise, orderIndex: Int = 0) {
        self.exercise = exercise
        self.orderIndex = orderIndex
    }
}
