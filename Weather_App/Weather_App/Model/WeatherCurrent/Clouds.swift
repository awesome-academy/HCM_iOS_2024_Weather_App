//
//  Cloud.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

struct Clouds: Codable {
    var numberOfClouds: Int
    
    enum CodingKeys: String, CodingKey {
        case numberOfClouds = "all"
    }
}
