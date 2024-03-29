//
//  Weather.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct WeatherCurrent: Codable {
    var coordinate: Coordinate
    var weathers: [Weather]
    var temperatureCurrent: TemperatureCurrent
    var wind: Wind
    var clouds: Clouds
    var dateTime: Int
    var timeOfSun: TimeOfSun
    var timezone: Int
    var nameCity: String
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weathers = "weather"
        case temperatureCurrent = "main"
        case wind
        case clouds
        case dateTime = "dt"
        case timeOfSun = "sys"
        case timezone
        case nameCity = "name"
    }
}
