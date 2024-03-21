//
//  Weather Data.swift
//  Weather_App
//
//  Created by ho.bao.an on 21/03/2024.
//

import Foundation

struct WeatherForecast: Codable {
    var numberOfDays: Int
    var WeatherDataList: [WeatherData]
    
    enum CodingKeys: String, CodingKey {
        case numberOfDays = "cnt"
        case WeatherDataList = "list"
    }
}
