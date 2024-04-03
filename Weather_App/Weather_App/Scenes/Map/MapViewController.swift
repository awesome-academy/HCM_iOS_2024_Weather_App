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
    
    private let weatherRepository: WeatherRepository = WeatherAPIRepository()
    private var locationSearchController = LocationSearchController()
    private var locationManager = LocationManager.shared
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let weatherForecastCoreDataManager = WeatherForecastCoreDataManager.shared
    private var isFavorite = false
    private var isFirstLaunch = true
    private var nameCitySaved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpSearchController()
    }
    
    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkStatusActive()
    }
    
    private func checkStatusActive() {
        if isFirstLaunch {
            checkNetwork()
            isFirstLaunch = false
        }
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
        locationManager.setRegion(on: mapView,
                                  center: userLocation.coordinate,
                                  latitudinalMeters: Constants.latitudinalMeters,
                                  longitudinalMeters: Constants.longitudinalMeters)
        fetchCurrentWeather(latitude: userLocation.coordinate.latitude,
                            longitude: userLocation.coordinate.longitude) { [weak self] weatherCurrent in
            guard let self = self else { return }
            weatherCurrentCoreDataManager.deleteDataWithUserLocation()
            weatherCurrentCoreDataManager.updateStatusUserLocation(for: weatherCurrent.nameCity, userLocation: true)
        }
        fetchForecastWeather(latitude: userLocation.coordinate.latitude,
                             longitude: userLocation.coordinate.longitude) { [weak self] weatherForecast in
            guard let self = self else { return }
            weatherForecastCoreDataManager.deleteAllUserLocations(withUserLocation: true) { result in
                switch result {
                case .success(let deletedCount):
                    print("Successfully deleted \(deletedCount) user locations with user location true")
                case .failure(let error):
                    print("Error deleting user locations: \(error)")
                }
            }
            weatherForecastCoreDataManager.updateStatusUserLocation(for: weatherForecast.city.nameCity, userLocation: true) { error in
                if let error = error {
                    print("Error updating user location: \(error)")
                } else {
                    print("Successfully updated user location")
                }
            }
        }
    }
    
    @IBAction private func getUserLocationButtonTapped(_ sender: Any) {
        getRegionMapOnUserLocation()
    }
    
    func didSelectLocation(name: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
        locationManager.setRegion(on: mapView, center: coordinate,
                                  latitudinalMeters: Constants.latitudinalMeters,
                                  longitudinalMeters: Constants.longitudinalMeters)
        fetchCurrentWeather(latitude: coordinate.latitude,
                            longitude: coordinate.longitude) {_ in }
        fetchForecastWeather(latitude: coordinate.latitude,
                             longitude: coordinate.longitude) {_ in}
        searchController.dismiss(animated: true)
    }
}

// MARK: - Fetch API and Save data to Coredata

extension MapViewController {
    private func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherCurrent) -> Void) {
        weatherRepository.getWeatherCurrent(latMapKit: latitude, lonMapKit: longitude) { result in
            switch result {
            case .success(let weatherCurrent):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.nameCitySaved = weatherCurrent.nameCity
                    self.weatherCurrentCoreDataManager.saveWeatherToCoreData(weatherCurrent: weatherCurrent) { error in
                        if let error = error {
                            print("Failed to save weather data: \(error)")
                        } else {
                            print("Weather data saved successfully")
                        }
                    }
                    if let savedWeatherData = self.weatherCurrentCoreDataManager.fetchWeatherEntity() {
                        for weatherEntity in savedWeatherData {
                            self.updateUIWithData(weatherEntity)
                        }
                    }
                    completion(weatherCurrent)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentErrorAlert(title: "ERROR", message: "No weather data")
                }
            }
        }
    }
    
    private func fetchForecastWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherForecast) -> Void) {
        weatherRepository.getWeatherForecast(latMapKit: latitude, lonMapKit: longitude) { result in
            switch result {
            case .success(let weatherForecast):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.weatherForecastCoreDataManager.saveWeatherForecastToCoreData(weatherForecast: weatherForecast) { error in
                        if let error = error {
                            print("Failed to save weather forecast data: \(error)")
                        } else {
                            print("Weather data saved forecast successfully")
                        }
                    }
                    completion(weatherForecast)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentErrorAlert(title: "ERROR", message: "No weather data")
                }
            }
        }
    }
}

// MARK: - Update status favorite CoreData and update status button favorite

extension MapViewController {
    @IBAction private func favoriteButtonTapped(_ sender: Any) {
        isFavorite.toggle()
        updateFavoriteButtonImage()
        weatherCurrentCoreDataManager.updateSaveStatus(for: nameCitySaved, saveStatus: isFavorite)
    }
    
    private func updateFavoriteButtonImage() {
        let imageName = isFavorite ? Constants.favoritedStatus : Constants.notFavotiteStatus
        let image = UIImage(named: imageName)
        favoriteButton.setImage(image, for: .normal)
    }
    
    private func updateFavoriteButtonStatus(for cityName: String) {
        isFavorite = weatherCurrentCoreDataManager.fetchCityWeatherEntity(for: cityName)?.saveStatus ?? false
        updateFavoriteButtonImage()
    }
}

// MARK: - Check internet connection

extension MapViewController {
    private func checkNetwork() {
        if NetworkMonitor.shared.isNetworkConnected() {
            configureMap()
        } else {
            self.presentErrorAlert(title: "ERROR", message: "Not Connected")
            if let savedWeatherData = weatherCurrentCoreDataManager.fetchUserLocationWeatherEntities() {
                for weatherEntity in savedWeatherData {
                    updateUIWithData(weatherEntity)
                }
            }
        }
    }
}

// MARK: - Update data to UI

extension MapViewController {
    private func updateUIWithData(_ weatherEntity: WeatherEntity) {
        nameCityLabel.text = weatherEntity.nameCity
        temperatureLabel.text = weatherEntity.temperature
        if let icon = weatherEntity.statusIcon {
            statusImageView.loadImage(withIcon: icon)
        } else {
            statusImageView.image = UIImage.wifiSlashImage()
        }
        if let cityName = weatherEntity.nameCity {
            updateFavoriteButtonStatus(for: cityName)
        }
    }
}
