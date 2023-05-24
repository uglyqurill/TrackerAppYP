import Foundation
import UIKit

class MockData {
    static var categories: [TrackerCategory] = [
        TrackerCategory(name: "Домашний уют", trackers: [
            Tracker(id: UUID(),
                    label: "Полить растение",
                    color: UIColor(hex: "#33CF69") ?? .gray,
                    emoji: "🏝",
                    dailySchedule: [.wednesday, .saturday]),
            Tracker(id: UUID(),
                    label: "Убраться в квартире",
                    color: UIColor(hex: "#FF881E") ?? .gray,
                    emoji: "😪",
                    dailySchedule: [.saturday]),
            Tracker(id: UUID(),
                    label: "Помыть посуду",
                    color: UIColor(hex: "#FD4C49") ?? .gray,
                    emoji: "🙂",
                    dailySchedule: [.monday, .saturday, .wednesday, .friday, .sunday, .thursday,.tuesday])
        ]),
        
        TrackerCategory(name: "Продуктивность", trackers: [
            Tracker(id: UUID(),
                    label: "Прога",
                    color: UIColor(hex: "#7994F5") ?? .gray,
                    emoji: "👨‍💻",
                    dailySchedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday]),
            Tracker(id: UUID(),
                    label: "Чтение",
                    color: UIColor(hex: "#FF99CC") ?? .gray,
                    emoji: "📚",
                    dailySchedule: [.monday, .saturday, .wednesday, .sunday, .thursday])
        ]),
        
        //Трекеры вари
        TrackerCategory(name: "Girly Lifestyle", trackers: [
            Tracker(id: UUID(),
                    label: "Лимфодренажная зарядка",
                    color: UIColor(hex: "#F9D4D4") ?? .gray,
                    emoji: "🧊",
                    dailySchedule: [.tuesday, .wednesday, .friday, .saturday, .sunday]),
            Tracker(id: UUID(),
                    label: "Медитация",
                    color: UIColor(hex: "#F9D4D4") ?? .gray,
                    emoji: "🪷",
                    dailySchedule: [.monday, .tuesday, .wednesday, .thursday, .saturday]),
            Tracker(id: UUID(),
                    label: "Массаж для лица",
                    color: UIColor(hex: "#F9D4D4") ?? .gray,
                    emoji: "💆🏻‍♀️",
                    dailySchedule: [.monday, .wednesday, .friday])
        ]),
        
        TrackerCategory(name: "Тренировки", trackers: [
            Tracker(id: UUID(),
                    label: "Зал",
                    color: UIColor(hex: "#AD56DA") ?? .gray,
                    emoji: "🥇",
                    dailySchedule: [.monday, .wednesday, .friday]),
            Tracker(id: UUID(),
                    label: "Бассейн",
                    color: UIColor(hex: "#35347C") ?? .gray,
                    emoji: "🏊‍♀️",
                    dailySchedule: [.tuesday, .thursday, .saturday]),
            Tracker(id: UUID(),
                    label: "Бег",
                    color: UIColor(hex: "#FF674D") ?? .gray,
                    emoji: "🏃‍♂️",
                    dailySchedule: [.wednesday, .sunday])
        ]),
        
        TrackerCategory(name: "Created", trackers: [
        ])
    ]
}
