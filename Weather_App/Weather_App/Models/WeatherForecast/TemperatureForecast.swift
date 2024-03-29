//
//  Temperature.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct TemperatureForecast: Codable {
    let temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "day"
    }
}
