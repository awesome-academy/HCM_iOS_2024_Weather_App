//
//  WeatherCoreDataRepository.swift
//  Weather_App
//
//  Created by ho.bao.an on 08/04/2024.
//

import Foundation

protocol WeatherCoreDataRepository {
    func getWeatherData() -> [WeatherEntity]?
    func getWeatherForecastData() -> [WeatherForecastEntity]?
}
