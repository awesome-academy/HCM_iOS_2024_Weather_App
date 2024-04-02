//
//  WeatherCurrentCoreDataManager.swift
//  Weather_App
//
//  Created by ho.bao.an on 28/03/2024.
//

import Foundation
import CoreData

class WeatherCurrentCoreDataManager {
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
            return nil
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
    
    func saveWeatherToCoreData(weatherCurrent: WeatherCurrent) {
        let context = coreDataManager.persistentContainer.viewContext
        let weatherEntity = WeatherEntity(context: context)
        weatherEntity.latitude = weatherCurrent.coordinate.latitude
        weatherEntity.longitude = weatherCurrent.coordinate.longitude
        weatherEntity.nameCity = weatherCurrent.nameCity
        weatherEntity.descriptionStatus = weatherCurrent.weathers.description
        weatherEntity.dateTime = weatherCurrent.dateString
        weatherEntity.temperature = weatherCurrent.temperatureInCelsius
        weatherEntity.humidity = weatherCurrent.humidityString
        weatherEntity.clouds = weatherCurrent.cloudsString
        weatherEntity.statusIcon = weatherCurrent.weatherStatus
        weatherEntity.sunrise = weatherCurrent.sunriseString
        weatherEntity.sunset = weatherCurrent.sunsetString
        do {
            try coreDataManager.addData(data: weatherEntity)
        } catch {
            print("Failed to save weather data: \(error)")
        }
    }
    
    func updateSaveStatus(for cityName: String, saveStatus: Bool) {
        guard let weatherEntity = fetchCityWeatherEntity(for: cityName) else {
            return
        }
        weatherEntity.saveStatus = saveStatus
        do {
            try coreDataManager.persistentContainer.viewContext.save()
        } catch {
            print("Error updating save status and location: \(error)")
        }
    }
    
    func updateStatusUserLocation(for cityName: String, userLocation: Bool) {
        guard let weatherEntity = fetchCityWeatherEntity(for: cityName) else {
            return
        }
        weatherEntity.userLocation = userLocation
        do {
            try coreDataManager.persistentContainer.viewContext.save()
        } catch {
            print("Error updating user location for \(cityName): \(error)")
        }
    }
    
    func deleteWeatherFromCoreData(weatherEntity: WeatherEntity) {
        do {
            try coreDataManager.deleteData(weatherEntity)
        } catch {
            print("Failed to delete weather data: \(error)")
        }
    }
    
    func deleteWeatherNotUsed() {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userLocation == %@ AND saveStatus == %@", NSNumber(value: false), NSNumber(value: false))
        do {
            let results = try context.fetch(fetchRequest)
            for entity in results {
                context.delete(entity)
            }
            try context.save()
            print("Successfully deleted weather entities not used")
        } catch {
            print("Error deleting weather entities with conditions: \(error)")
        }
    }
    
    func deleteDuplicateUserLocations(for cityName: String) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameCity == %@ AND userLocation == true", cityName)
        do {
            let results = try context.fetch(fetchRequest)
            for (index, entity) in results.enumerated() where index > 0 {
                context.delete(entity)
            }
            try context.save()
            print("Successfully deleted duplicate user locations for \(cityName)")
            
        } catch {
            print("Error deleting duplicate user locations for \(cityName): \(error)")
        }
    }
}
