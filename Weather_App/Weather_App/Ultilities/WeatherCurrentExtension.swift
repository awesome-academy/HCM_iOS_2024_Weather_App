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
}
