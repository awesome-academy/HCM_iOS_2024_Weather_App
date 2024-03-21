//
//  Weather.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct Weather: Codable {
    var description: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}
