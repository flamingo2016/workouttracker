import SwiftData

@Model
final class WorkoutSet {
    var reps: Int
    var weight: Double
    var orderIndex: Int
    var entry: WorkoutEntry?

    init(reps: Int = 0, weight: Double = 0, orderIndex: Int = 0) {
        self.reps = reps
        self.weight = weight
        self.orderIndex = orderIndex
    }
}
