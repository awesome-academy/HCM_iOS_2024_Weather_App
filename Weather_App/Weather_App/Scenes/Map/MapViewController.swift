//
//  MapViewController.swift
//  Weather_App
//
//  Created by ho.bao.an on 20/03/2024.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var informationWeatherView: UIView!
    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    private let searchController = UISearchController()
    private var location = (latitude: 0.0, longitude: 0.0)
    
    private var locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureMap()
        locationManager.delegate = self
    }
    
    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnUserLocation()
    }
}

extension MapViewController {
    func setUpUI() {
        informationWeatherView.layer.cornerRadius = Constants.cornerRadius
        informationWeatherView.addShadow()
        statusView.layer.cornerRadius = Constants.cornerRadius
        statusView.addShadow()
        navigationItem.searchController = searchController
        customizeNavigationController()
        customizeSearchController(searchController: searchController)
    }
    
    private func configureMap() {
        mapView.showsUserLocation = true
        centerMapOnUserLocation()
    }
    
    private func centerMapOnUserLocation() {
        if let userLocation = locationManager.getCurrentLocation() {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: Constants.latitudinalMeters,
                longitudinalMeters: Constants.longitudinalMeters
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction private func getUserLocationButtonTapped(_ sender: Any) {
        centerMapOnUserLocation()
    }
}

extension MapViewController: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        location.latitude = latitude
        location.longitude = longitude
    }
}
