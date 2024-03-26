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
    private var locationUpdate = (latitude: 0.0, longitude: 0.0)
    
    private let weatherRepository: WeatherRepository = WeatherAPIRepository()
    private var locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureMap()
        locationManager.delegate = self
    }
    
    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRegionMapOnUserLocation()
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
        getRegionMapOnUserLocation()
    }
    
    private func getRegionMapOnUserLocation() {
        guard let userLocation = locationManager.getCurrentLocation() else {
            locationManager.startUpdatingLocation()
            return
        }
        fetchCurrentWeather(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: Constants.latitudinalMeters,
            longitudinalMeters: Constants.longitudinalMeters
        )
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction private func getUserLocationButtonTapped(_ sender: Any) {
        getRegionMapOnUserLocation()
    }
}

extension MapViewController: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        locationUpdate = (latitude: latitude, longitude: longitude)
    }
}

extension MapViewController {
    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        weatherRepository.getWeatherCurrent(latMapKit: latitude, lonMapKit: longitude) { result in
            switch result {
            case .success(let weatherCurrent):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.updateUIWithData(weatherCurrent)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentErrorAlert(title: "ERROR", message: "No weather data")
                }
            }
        }
    }
    
    private func updateUIWithData(_ weatherCurrent: WeatherCurrent) {
        nameCityLabel.text = weatherCurrent.nameCity
        temperatureLabel.text = weatherCurrent.temperatureInCelsius
        if let icon = weatherCurrent.weatherStatus {
            statusImageView.loadImage(withIcon: icon)
        }
    }
}
