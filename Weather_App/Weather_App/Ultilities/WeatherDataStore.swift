//
//  WeatherDataStore.swift
//  Weather_App
//
//  Created by ho.bao.an on 03/04/2024.
//

import Foundation
import CoreData

class WeatherDataStore {
    static let shared = WeatherDataStore()
    
    private init() {}
    
    var currentWeatherData: WeatherCurrent?
    var forecastWeatherData: WeatherForecast?
    
}
