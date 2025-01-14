//
//  MapService.swift
//  Weather_App
//
//  Created by ho.bao.an on 26/03/2024.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    weak var delegate: LocationManagerDelegate?
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        delegate?.didUpdateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
    
    func setRegion(on mapView: MKMapView,
                   center: CLLocationCoordinate2D,
                   latitudinalMeters: CLLocationDistance,
                   longitudinalMeters: CLLocationDistance) {
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters
        )
        mapView.setRegion(region, animated: true)
    }
    
    func requestBackgroundLocationAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func getLocationInBackground() -> CLLocation? {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return nil
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
        return locationManager.location
    }
}
