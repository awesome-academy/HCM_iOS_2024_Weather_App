//
//  OnlineWeatherDataService.swift
//  Weather_App
//
//  Created by ho.bao.an on 08/04/2024.
//

import Foundation

final class OnlineWeatherDataService: WeatherCoreDataRepository {
    
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let weatherForecastCoreDataManager = WeatherForecastCoreDataManager.shared
    
    func getWeatherData() -> [WeatherEntity]? {
        return weatherCurrentCoreDataManager.fetchWeatherEntity()
    }
    
    func getWeatherForecastData() -> [WeatherForecastEntity]? {
        var weatherForecastData: [WeatherForecastEntity]?
        weatherForecastCoreDataManager.fetchWeatherForecastEntities { (data, error) in
            weatherForecastData = data
        }
        return weatherForecastData
    }
}
