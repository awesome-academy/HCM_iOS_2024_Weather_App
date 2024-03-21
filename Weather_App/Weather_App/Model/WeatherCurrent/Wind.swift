//
//  Wind.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct Wind: Codable {
    var speed: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
    }
}
