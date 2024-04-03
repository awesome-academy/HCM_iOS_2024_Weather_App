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
    
    func saveContext(completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func fetchData<T: NSManagedObject>(completion: @escaping (Result<[T], Error>) -> Void) {
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
            completion(.failure(CoreDataError.fetchFailed("Failed to create fetch request")))
            return
        }
        let context = persistentContainer.viewContext
        do {
            let fetchedData = try context.fetch(fetchRequest)
            completion(.success(fetchedData))
        } catch {
            completion(.failure(CoreDataError.fetchFailed(error.localizedDescription)))
        }
    }
    
    func addData<T: NSManagedObject>(data: T, completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        context.insert(data)
        saveContext(completion: completion)
    }
    
    func deleteData<T: NSManagedObject>(_ data: T, completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        context.delete(data)
        saveContext(completion: completion)
    }
    
    func deleteAllData<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, completion: @escaping (Result<Int, Error>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        fetchRequest.predicate = predicate
        do {
            let objects = try context.fetch(fetchRequest)
            for case let object as NSManagedObject in objects {
                context.delete(object)
            }
            saveContext { error in
                if let error = error {
                    completion(.failure(CoreDataError.deleteFailed(error.localizedDescription)))
                } else {
                    completion(.success(objects.count))
                }
            }
        } catch {
            completion(.failure(CoreDataError.deleteFailed(error.localizedDescription)))
        }
    }
}
