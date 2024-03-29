//
//  WeatherDetail.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct TemperatureCurrent: Codable {
    var temperature: Double
    var humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
    }
}
