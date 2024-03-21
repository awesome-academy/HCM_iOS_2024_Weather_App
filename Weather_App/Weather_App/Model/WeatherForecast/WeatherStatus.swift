//
//  Weather.swift
//  Weather_App
//
//  Created by ho.bao.an on 21/03/2024.
//

import Foundation

struct WeatherStatus: Codable {
    var description: String
    var icon: String

    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}
