//
//  WeatherCurrentCoreDataManager.swift
//  Weather_App
//
//  Created by ho.bao.an on 28/03/2024.
//

import Foundation
import CoreData

final class WeatherCurrentCoreDataManager {
    static let shared = WeatherCurrentCoreDataManager()
    private let coreDataManager = CoreDataManager.shared
    
    func fetchWeatherEntity() -> [WeatherEntity]? {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching all weather entities: \(error)")
            return []
        }
    }
    
    func fetchCityWeatherEntity(for cityName: String) -> WeatherEntity? {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameCity == %@", cityName)
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching favorite cities: \(error)")
            return nil
        }
    }
    
    func fetchWeatherEntitiesWithSaveStatus(completion: @escaping ([WeatherEntity]?, Error?) -> Void) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "saveStatus == %@", NSNumber(value: true))
        do {
            let results = try context.fetch(fetchRequest)
            completion(results, nil)
        } catch {
            print("Error fetching weather entities with save status true: \(error)")
            completion(nil, error)
        }
    }
    
    func fetchUserLocationWeatherEntities() -> [WeatherEntity]? {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userLocation == %@", NSNumber(value: true))
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching user location weather entities: \(error)")
            return nil
        }
    }
    
    func saveWeatherToCoreData(weatherCurrent: WeatherCurrent, completion: @escaping (Error?) -> Void) {
        let context = coreDataManager.persistentContainer.viewContext
        let weatherEntity = WeatherEntity(context: context)
        weatherEntity.saveStatus = false
        weatherEntity.userLocation = false
        weatherEntity.latitude = weatherCurrent.coordinate.latitude
        weatherEntity.longitude = weatherCurrent.coordinate.longitude
        weatherEntity.nameCity = weatherCurrent.nameCity
        weatherEntity.descriptionStatus = weatherCurrent.descriptionString
        weatherEntity.dateTime = weatherCurrent.dateString
        weatherEntity.temperature = weatherCurrent.temperatureInCelsius
        weatherEntity.humidity = weatherCurrent.humidityString
        weatherEntity.clouds = weatherCurrent.cloudsString
        weatherEntity.statusIcon = weatherCurrent.weatherStatus
        weatherEntity.sunrise = weatherCurrent.sunriseString
        weatherEntity.sunset = weatherCurrent.sunsetString
        weatherEntity.wind = weatherCurrent.windString
        coreDataManager.addData(data: weatherEntity) { error in
            if let error = error {
                completion(error)
                print("Failed to save weather data: \(error)")
            } else {
                completion(nil)
                print("Weather data saved successfully")
            }
        }
    }
    
    
    func updateSaveStatus(for cityName: String, saveStatus: Bool) {
        guard let weatherEntity = fetchCityWeatherEntity(for: cityName) else {
            return
        }
        weatherEntity.saveStatus = saveStatus
        do {
            try coreDataManager.persistentContainer.viewContext.save()
            print("Success updating save status for \(cityName)")
        } catch {
            print("Error updating save status for \(cityName): \(error)")
        }
    }
    
    func updateStatusUserLocation(for cityName: String, userLocation: Bool) {
        guard let weatherEntity = fetchCityWeatherEntity(for: cityName) else {
            return
        }
        weatherEntity.userLocation = userLocation
        do {
            try coreDataManager.persistentContainer.viewContext.save()
            print("Success updating user location for \(cityName)")
        } catch {
            print("Error updating user location for \(cityName): \(error)")
        }
    }
    
    func deleteWeatherFromCoreData(weatherEntity: WeatherEntity, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.deleteData(weatherEntity) { error in
            if let error = error {
                print("Failed to delete weather data: \(error)")
                completion(error)
            } else {
                print("Weather data deleted successfully")
                completion(nil)
            }
        }
    }
    
    func deleteDataNotUsed() {
        let predicate = NSPredicate(format: "saveStatus == false AND userLocation == false")
        CoreDataManager.shared.deleteAllData(WeatherEntity.self, predicate: predicate) { result in
            switch result {
            case .success(let deletedCount):
                print("Successfully deleted \(deletedCount) weather data not used")
            case .failure(let error):
                print("Error deleting weather data not used: \(error)")
            }
        }
    }
    
    func deleteDataWithUserLocation(completion: @escaping (Result<Int, Error>) -> Void) {
        let predicate = NSPredicate(format: "userLocation == %@ && saveStatus == %@", NSNumber(value: true), NSNumber(value: false))
        coreDataManager.deleteAllData(WeatherEntity.self, predicate: predicate) { result in
            switch result {
            case .success(let deletedCount):
                print("Successfully deleted \(deletedCount) entities with userLocation")
                completion(.success(deletedCount))
            case .failure(let error):
                print("Error deleting entities with userLocation: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteAllData() {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WeatherEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            print("Successfully deleted all weather entities")
        } catch {
            print("Error deleting all weather entities: \(error)")
        }
    }
}
