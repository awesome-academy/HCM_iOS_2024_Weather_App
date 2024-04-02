//
//  File.swift
//  Weather_App
//
//  Created by ho.bao.an on 26/03/2024.
//

import Foundation

extension WeatherCurrent {
    
    var temperatureInCelsius: String {
        let temperatureCelsius = Int(self.temperatureCurrent.temperature)
        return "\(temperatureCelsius)℃"
    }
    
    var weatherStatus: String? {
        return self.weathers.first?.icon
    }
    
    var humidityString: String {
        return "\(self.temperatureCurrent.humidity)%"
    }
    
    var cloudsString: String {
        return "\(self.clouds.numberOfClouds)%"
    }
    
    var windString: String {
        return "\(self.wind.speed) m/s"
    }
    
    var dateString: String {
        let timestamp = TimeInterval(self.dateTime)
        let date = Date.dateFromTimestamp(timestamp)
        let dateString = date.convertToDateString()
        return "\(dateString)"
    }
    
    var sunriseString: String {
        let timestamp = TimeInterval(self.timeOfSun.sunrise)
        let date = Date.dateFromTimestamp(timestamp)
        let timeString = date.convertToTimeString()
        return "\(timeString)"
    }
    
    var sunsetString: String {
        let timestamp = TimeInterval(self.timeOfSun.sunset)
        let date = Date.dateFromTimestamp(timestamp)
        let timeString = date.convertToTimeString()
        return "\(timeString)"
    }
}

