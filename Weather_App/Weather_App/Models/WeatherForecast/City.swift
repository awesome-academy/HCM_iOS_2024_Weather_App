//
//  City.swift
//  Weather_App
//
//  Created by ho.bao.an on 21/03/2024.
//

import Foundation

struct City: Codable {
    var nameCity: String
    var coordinate: Coordinate
    var country: String
    var timezone: Int
    
    enum CodingKeys: String, CodingKey {
        case nameCity = "name"
        case coordinate = "coord"
        case country
        case timezone
    }
}
