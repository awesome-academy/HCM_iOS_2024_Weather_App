//
//  WeatherForecastCoreDataManager.swift
//  Weather_App
//
//  Created by ho.bao.an on 03/04/2024.
//

import Foundation
import CoreData

final class WeatherForecastCoreDataManager {
    static let shared = WeatherForecastCoreDataManager()
    private let coreDataManager = CoreDataManager.shared
    
    func fetchWeatherForecastEntities(completion: @escaping ([WeatherForecastEntity]?, Error?) -> Void) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherForecastEntity> = WeatherForecastEntity.fetchRequest()
        do {
            let weatherForecastEntities = try context.fetch(fetchRequest)
            completion(weatherForecastEntities, nil)
        } catch {
            print("Failed to fetch weather forecast entities: \(error)")
            completion(nil, error)
        }
    }
    
    func fetchCityWeatherForcastEntity(for cityName: String, completion: @escaping (WeatherForecastEntity?, Error?) -> Void) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherForecastEntity> = WeatherForecastEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameCity == %@", cityName)
        do {
            let results = try context.fetch(fetchRequest)
            completion(results.first, nil)
        } catch {
            print("Error fetching cities: \(error)")
            completion(nil, error)
        }
    }
    
    func fetchWeatherForecastEntitiesWithUserLocation(completion: @escaping ([WeatherForecastEntity]?, Error?) -> Void) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherForecastEntity> = WeatherForecastEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userLocation == %@", NSNumber(value: true))
        
        do {
            var results = try context.fetch(fetchRequest)
            for forecastEntity in results {
                if let weatherDataList = forecastEntity.weatherData as? Set<WeatherDataEntity> {
                    let sortedWeatherDataList = weatherDataList.sorted { $0.index < $1.index }
                    forecastEntity.weatherData = NSSet(array: sortedWeatherDataList)
                }
            }
            completion(results, nil)
        } catch {
            print("Error fetching weather forecast entities with user location: \(error)")
            completion(nil, error)
        }
    }
    
    func saveWeatherForecastToCoreData(weatherForecast: WeatherForecast, completion: @escaping (Error?) -> Void) {
        let context = coreDataManager.persistentContainer.viewContext
        let weatherForecastEntity = WeatherForecastEntity(context: context)
        weatherForecastEntity.nameCity = weatherForecast.city.nameCity
        weatherForecastEntity.userLocation = false
        var index = 0
        for weatherData in weatherForecast.WeatherDataList {
            let weatherDataEntity = WeatherDataEntity(context: context)
            weatherDataEntity.temperature = weatherData.temperatureInCelsius
            weatherDataEntity.date = weatherData.dateString
            weatherDataEntity.descriptionStatus = weatherData.description
            weatherDataEntity.index = Int16(index)
            weatherDataEntity.weatherForecast = weatherForecastEntity
            weatherDataEntity.statusIcon = weatherData.weatherStatusIcon
            index += 1
        }
        coreDataManager.addData(data: weatherForecastEntity) { error in
            if let error = error {
                print("Failed to save weather data: \(error)")
                completion(error)
            } else {
                print("Weather data saved successfully")
                completion(nil)
            }
        }
    }
    
    func updateStatusUserLocation(for cityName: String, userLocation: Bool, completion: @escaping (Error?) -> Void) {
        fetchCityWeatherForcastEntity(for: cityName) { (weatherForecastEntity, error) in
            if let error = error {
                completion(error)
                return
            }
            guard let weatherForecastEntity = weatherForecastEntity else {
                completion(NSError(domain: "WeatherForecastCoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "City forecast not found"]))
                return
            }
            weatherForecastEntity.userLocation = userLocation
            do {
                try self.coreDataManager.persistentContainer.viewContext.save()
                print("Success updating user location forecast \(cityName)")
                completion(nil)
            } catch {
                print("Error updating user location forecast \(cityName): \(error)")
                completion(error)
            }
        }
    }
    
    func deleteAllUserLocations(withUserLocation userLocation: Bool, completion: @escaping (Result<Int, Error>) -> Void) {
        let predicate = NSPredicate(format: "userLocation == %@", NSNumber(value: userLocation))
        CoreDataManager.shared.deleteAllData(WeatherForecastEntity.self, predicate: predicate) { result in
            switch result {
            case .success(let deletedCount):
                print("Successfully deleted \(deletedCount) weather forecast entities with user location: \(userLocation)")
                completion(.success(deletedCount))
            case .failure(let error):
                print("Error deleting weather forecast entities with user location: \(error)")
                completion(.failure(error))
            }
        }
    }
}
