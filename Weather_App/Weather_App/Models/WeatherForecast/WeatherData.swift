//
//  Weather Forecast.swift
//  Weather_App
//
//  Created by ho.bao.an on 21/03/2024.
//

import Foundation

struct WeatherData: Codable {
    var dateTime: Int
    var sunrise: Int
    var sunset: Int
    var temperatureForecast: TemperatureForecast
    var pressure: Int
    var humidity: Int
    var weatherStatus: [WeatherStatus]
    var speed: Double
    var clouds: Int
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case sunrise
        case sunset
        case temperatureForecast = "temp"
        case pressure
        case humidity
        case weatherStatus = "weather"
        case speed
        case clouds
    }
}
