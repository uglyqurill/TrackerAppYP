import UIKit

struct TrackerCategory {
    let name: String
    var trackers: [Tracker]
    
    func visibleTrackers(filterString: String) -> [Tracker] {
        if filterString.isEmpty {
            return trackers
        } else {
            return trackers.filter { $0.label.lowercased().contains(filterString.lowercased()) }
        }
    }
}
