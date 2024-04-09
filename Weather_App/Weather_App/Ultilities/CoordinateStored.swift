//
//  CoordinateStored.swift
//  Weather_App
//
//  Created by ho.bao.an on 09/04/2024.
//

import Foundation

final class CoordinateStored {
    static let shared = CoordinateStored()
    
    var latitudeStored: Double?
    var longitudeStored: Double?
    
    private init() {}
    
    func setCoordinates(latitude: Double, longitude: Double) {
        self.latitudeStored = latitude
        self.longitudeStored = longitude
    }
    
    func getCoordinates() -> (latitude: Double?, longitude: Double?) {
        return (latitudeStored, longitudeStored)
    }
}
