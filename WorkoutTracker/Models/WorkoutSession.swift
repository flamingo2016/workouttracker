import SwiftData
import Foundation

@Model
final class WorkoutSession {
    var date: Date
    var name: String

    @Relationship(deleteRule: .cascade)
    var entries: [WorkoutEntry] = []

    init(name: String = "", date: Date = .now) {
        self.date = date
        self.name = name.isEmpty ? WorkoutSession.defaultName(for: date) : name
    }

    static func defaultName(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return "\(f.string(from: date)) Workout"
    }

    var totalVolume: Double {
        entries.flatMap(\.sets).reduce(0) { $0 + $1.weight * Double($1.reps) }
    }

    var totalSets: Int { entries.flatMap(\.sets).count }
}
