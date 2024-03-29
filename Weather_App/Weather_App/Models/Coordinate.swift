//
//  Coord.swift
//  Weather_App
//
//  Created by ho.bao.an on 21/03/2024.
//

import Foundation

struct Coordinate: Codable {
    var longitude: Double
    var latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
