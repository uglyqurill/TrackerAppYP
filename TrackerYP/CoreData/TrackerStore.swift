import Foundation
import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidName
}

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    convenience override init() {
        let context = DatabaseManager.shared.context
        try! self.init(context: context)
    }
    
    var trackers: [Tracker] {
        guard let objects = self.fetchedResultsController.fetchedObjects, let trackers = try? objects.map({ try self.tracker(from: $0)})
        else { return [] }
        return trackers
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.label, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateExistingTracker(trackerCoreData, with: tracker)
        try context.save()
    }
    
    func togglePinTracker(_ tracker: Tracker) throws {
        let tracker = fetchedResultsController.fetchedObjects?.first {
            $0.id == tracker.id
        }
        tracker?.pinned = !(tracker?.pinned ?? false)
        try context.save()
    }
    
    func updateTracker(
        newNameTracker: String,
        newEmoji: String,
        newColor: String,
        newSchedule: [WeekDay],
        categoryName: String,
        editableTracker: Tracker) throws {
            let tracker = fetchedResultsController.fetchedObjects?.first {
                $0.id == editableTracker.id
            }
            tracker?.label = newNameTracker
            tracker?.emoji = newEmoji
            tracker?.color = newColor
            tracker?.dailySchedule = newSchedule.compactMap { $0.rawValue }
            try context.save()
        }
    
    func deleteTracker(_ trackerToDelete: Tracker) throws {
        let tracker = fetchedResultsController.fetchedObjects?.first {
            $0.id == trackerToDelete.id
        }
        if let tracker = tracker {
            context.delete(tracker)
            try context.save()
        }
    }
    
    func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.label = tracker.label
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.dailySchedule = tracker.dailySchedule?.compactMap { $0.rawValue }
        trackerCoreData.color = tracker.color?.hexString
    }
    
    func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = TrackerCoreData.fetchRequest()
        let trackersFromCoreData = try context.fetch(fetchRequest)
        return try trackersFromCoreData.map { try self.tracker(from: $0) }
    }
    
    func tracker(from data: TrackerCoreData) throws -> Tracker {
        guard let name = data.label else {
            throw DatabaseError.someError
        }
        guard let uuid = data.id else {
            throw DatabaseError.someError
        }
        guard let emoji = data.emoji else {
            throw DatabaseError.someError
        }
        guard let schedule = data.dailySchedule else {
            throw DatabaseError.someError
        }
        guard let color = data.color else {
            throw DatabaseError.someError
        }
        let pinned = data.pinned
        
        return Tracker(
            id: uuid,
            label: name,
            color: color.color,
            emoji: emoji,
            dailySchedule: schedule.compactMap { WeekDay(rawValue: $0) },
            pinned: pinned
        )
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            insertedIndexes = IndexSet()
            deletedIndexes = IndexSet()
            updatedIndexes = IndexSet()
            movedIndexes = Set<TrackerStoreUpdate.Move>()
        }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            delegate?.store(
                self,
                didUpdate: TrackerStoreUpdate(
                    insertedIndexes: insertedIndexes!,
                    deletedIndexes: deletedIndexes!,
                    updatedIndexes: updatedIndexes!,
                    movedIndexes: movedIndexes!
                )
            )
            insertedIndexes = nil
            deletedIndexes = nil
            updatedIndexes = nil
            movedIndexes = nil
        }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}
