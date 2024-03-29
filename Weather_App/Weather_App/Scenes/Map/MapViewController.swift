//
//  MapViewController.swift
//  Weather_App
//
//  Created by ho.bao.an on 20/03/2024.
//

import UIKit
import MapKit
import CoreData

final class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var informationWeatherView: UIView!
    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    private var searchController = UISearchController()
    private var locationUpdate = (latitude: 0.0, longitude: 0.0)
    
    private let weatherRepository: WeatherRepository = WeatherAPIRepository()
    private var locationSearchController = LocationSearchController()
    private var locationManager = LocationManager.shared
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private var currentWeatherData: WeatherCurrent?
    private var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpSearchController()
        configureMap()
        locationManager.delegate = self
    }
    
    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRegionMapOnUserLocation()
    }
}

// MARK: - Setup UI

extension MapViewController {
    func setUpUI() {
        informationWeatherView.layer.cornerRadius = Constants.cornerRadius
        informationWeatherView.addShadow()
        statusView.layer.cornerRadius = Constants.cornerRadius
        statusView.addShadow()
    }
    
    func setUpSearchController() {
        searchController = UISearchController(searchResultsController: locationSearchController)
        navigationItem.searchController = searchController
        customizeNavigationController()
        customizeSearchController(searchController: searchController)
        searchController.searchResultsUpdater = locationSearchController
        locationSearchController.delegate = self
        definesPresentationContext = true
    }
}

// MARK: - Setup map and handle action map

extension MapViewController: LocationSearchDelegate {
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
        locationManager.setRegion(on: mapView,
                                  center: userLocation.coordinate,
                                  latitudinalMeters: Constants.latitudinalMeters,
                                  longitudinalMeters: Constants.longitudinalMeters)
    }
    
    @IBAction private func getUserLocationButtonTapped(_ sender: Any) {
        getRegionMapOnUserLocation()
    }
    
    func didSelectLocation(name: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
        fetchCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locationManager.setRegion(on: mapView, center: coordinate,
                                  latitudinalMeters: Constants.latitudinalMeters,
                                  longitudinalMeters: Constants.longitudinalMeters)
        searchController.dismiss(animated: true)
    }
}

extension MapViewController: LocationManagerDelegate {
    func didUpdateLocation(latitude: Double, longitude: Double) {
        locationUpdate = (latitude: latitude, longitude: longitude)
    }
}

// MARK: - Fetch API and update data to UI

extension MapViewController {
    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        weatherRepository.getWeatherCurrent(latMapKit: latitude, lonMapKit: longitude) { result in
            switch result {
            case .success(let weatherCurrent):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.updateUIWithData(weatherCurrent)
                    self.currentWeatherData = weatherCurrent
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
        updateFavoriteStatus(for: weatherCurrent.nameCity)
    }
}

// MARK: - Save/delete to CoreData and update status button favorite

extension MapViewController {
    @IBAction private func favoriteButtonTapped(_ sender: Any) {
        guard let weatherData = currentWeatherData else { return }
        if isFavorite, let weatherEntity = weatherCurrentCoreDataManager.fetchWeatherEntity(for: weatherData.nameCity) {
            weatherCurrentCoreDataManager.deleteWeatherFromCoreData(weatherEntity: weatherEntity)
            isFavorite = false
            updateFavoriteButtonImage()
        } else {
            weatherCurrentCoreDataManager.saveWeatherToCoreData(
                latitude: weatherData.coordinate.latitude,
                longitude: weatherData.coordinate.longitude,
                cityName: weatherData.nameCity)
            isFavorite = true
            updateFavoriteButtonImage()
        }
    }
    
    private func updateFavoriteButtonImage() {
        let imageName = isFavorite ? Constants.favoritedStatus : Constants.notFavotiteStatus
        let image = UIImage(named: imageName)
        favoriteButton.setImage(image, for: .normal)
    }
    
    private func updateFavoriteStatus(for cityName: String) {
        isFavorite = weatherCurrentCoreDataManager.fetchWeatherEntity(for: cityName) != nil
        updateFavoriteButtonImage()
    }
}
