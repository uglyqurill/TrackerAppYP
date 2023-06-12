import UIKit

struct Tracker: Hashable {
     let id: UUID
     let label: String
     let color: UIColor?
     let emoji: String?
     let dailySchedule: [WeekDay]?
 }
