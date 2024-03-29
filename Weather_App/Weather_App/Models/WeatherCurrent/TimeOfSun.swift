//
//  Sys.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct TimeOfSun: Codable {
    var country: String
    var sunrise: Int
    var sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }
}
