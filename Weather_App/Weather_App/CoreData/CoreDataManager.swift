//
//  CoreDataManager.swift
//  Weather_App
//
//  Created by ho.bao.an on 25/03/2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherFavoriteCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Core Data: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                throw CoreDataError.unresolvedError(nserror)
            }
        }
    }
    
    func fetchData<T: NSManagedObject>() throws -> [T] {
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
            throw CoreDataError.fetchFailed("Failed to create fetch request")
        }
        let context = persistentContainer.viewContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw CoreDataError.fetchFailed(error.localizedDescription)
        }
    }
    
    func addData<T: NSManagedObject>(data: T) throws {
        let context = persistentContainer.viewContext
        context.insert(data)
        do {
            try saveContext()
            print("Core Data: Save data success")
        } catch {
            throw CoreDataError.insertFailed(error.localizedDescription)
        }
    }
    
    func deleteData<T: NSManagedObject>(_ data: T) throws {
        let context = persistentContainer.viewContext
        context.delete(data)
        do {
            try saveContext()
            print("Core Data: Delete data success")
        } catch {
            throw CoreDataError.deleteFailed(error.localizedDescription)
        }
    }
}
