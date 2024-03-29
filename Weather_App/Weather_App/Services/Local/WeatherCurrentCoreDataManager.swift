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
    
    func fetchWeatherEntity(for cityName: String) -> WeatherEntity? {
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
    
    func saveWeatherToCoreData(latitude: Double, longitude: Double, cityName: String) {
        let context = coreDataManager.persistentContainer.viewContext
        let weatherEntity = WeatherEntity(context: context)
        weatherEntity.latitude = latitude
        weatherEntity.longitude = longitude
        weatherEntity.nameCity = cityName
        do {
            try coreDataManager.addData(data: weatherEntity)
        } catch {
            print("Failed to save weather data: \(error)")
        }
    }
    
    func deleteWeatherFromCoreData(weatherEntity: WeatherEntity) {
        do {
            try coreDataManager.deleteData(weatherEntity)
        } catch {
            print("Failed to delete weather data: \(error)")
        }
    }
}
