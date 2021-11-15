//
//  DataManager.swift
//  DeezerProject
//
//  Created by Steven Curtis on 05/03/2021.
//

import UIKit
import CoreData

public protocol DataManagerProtocol {
    func save(favourite: TrackApiDto, completion: (() -> Void)?)
    init()
    func getFavourites() throws -> [TrackApiDto]
    func delete(favourite: TrackApiDto, completion: (() -> Void)?) throws
}

final class DataManager: DataManagerProtocol {
    private var managedObjectContext: NSManagedObjectContext! = nil
    private var entity: NSEntityDescription! = nil

    init (objectContext: NSManagedObjectContext, entity: NSEntityDescription) {
        self.managedObjectContext = objectContext
        self.entity = entity
    }

    required init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        if let entityDescription = NSEntityDescription.entity(
            forEntityName: Constants.entityName,
            in: managedObjectContext
        ) {
            entity = entityDescription
        }
    }

    func getFavourites() throws -> [TrackApiDto] {
        let fetchRequest = NSFetchRequest<DBTrackStorage>(entityName: DBTrackStorage.entityName)
        let track: [DBTrackStorage]
        do {
            track = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            throw ErrorModel(errorDescription: "Core Data Error. Could not fetch. \(error), \(error.userInfo)")
        }
        if track.isEmpty {throw ErrorModel(errorDescription: "No Pairs")}
        return track.map {$0.toDto()}
    }

    func save(favourite: TrackApiDto, completion: (() -> Void)? = nil) {
        managedObjectContext.perform {
            let object = DBTrackStorage(entity: self.entity, insertInto: self.managedObjectContext)
            object.update(from: favourite)
            self.saveContext(completion: completion ?? {})
        }
    }

    func delete(favourite: TrackApiDto, completion: (() -> Void)?) throws {
        let fetchRequest = NSFetchRequest<DBTrackStorage>(entityName: DBTrackStorage.entityName)
        let track: [DBTrackStorage]
        do {
            track = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            throw ErrorModel(errorDescription: "Core Data Error. Could not fetch. \(error), \(error.userInfo)")
        }
        if let object = track.first(where: { $0.id.intValue == favourite.id }) {
            self.managedObjectContext.delete(object)

            if let completion = completion {
                self.saveContext(completion: completion)
            } else {
                self.saveContext {}
            }
        }
    }

    func saveContext(completion: @escaping () -> Void) {
        managedObjectContext.perform {
            do {
                try self.managedObjectContext.save()
                completion()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
