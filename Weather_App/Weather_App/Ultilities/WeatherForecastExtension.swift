//
//  WeatherForecastExtension.swift
//  Weather_App
//
//  Created by ho.bao.an on 03/04/2024.
//

import Foundation

extension WeatherData {
    var temperatureInCelsius: String {
        let temperatureCelsius = Int(self.temperatureForecast.temperature)
        return "\(temperatureCelsius)℃"
    }
    
    var dateString: String {
        let timestamp = TimeInterval(self.dateTime)
        let date = Date.dateFromTimestamp(timestamp)
        let dateString = date.convertToDayString()
        return dateString
    }
    
    var weatherStatusIcon: String? {
        return self.weatherStatus.first?.icon
    }
    
    var description: String? {
        return self.weatherStatus.first?.description
    }
}
