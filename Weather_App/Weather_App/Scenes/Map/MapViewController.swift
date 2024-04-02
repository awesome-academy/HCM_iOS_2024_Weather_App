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
    private var currentWeatherData: WeatherCurrent?
    private var isFavorite = false
    private var nameCitySaved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpSearchController()
        checkNetwork()
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
        weatherCurrentCoreDataManager.deleteDuplicateUserLocations(for: nameCitySaved)
        weatherCurrentCoreDataManager.updateStatusUserLocation(for: nameCitySaved, userLocation: true)
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

// MARK: - Fetch API and Save data to Coredata

extension MapViewController {
    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        weatherRepository.getWeatherCurrent(latMapKit: latitude, lonMapKit: longitude) { result in
            switch result {
            case .success(let weatherCurrent):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.updateUIWithAPIData(weatherCurrent)
                    self.weatherCurrentCoreDataManager.saveWeatherToCoreData(weatherCurrent: weatherCurrent)
                    self.nameCitySaved = weatherCurrent.nameCity
                    self.currentWeatherData = weatherCurrent
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

// MARK: - Check connection

extension MapViewController {
    private func checkNetwork() {
        if NetworkMonitor.shared.isNetworkConnected() {
            configureMap()
        } else {
            self.presentErrorAlert(title: "ERROR", message: "Not Connected")
            if let savedWeatherData = weatherCurrentCoreDataManager.fetchWeatherEntity() {
                for weatherEntity in savedWeatherData where weatherEntity.userLocation {
                    updateUIWithCoreData(weatherEntity)
                    break
                }
            }
        }
    }
}

// MARK: - Update data to UI

extension MapViewController {
    private func updateUIWithAPIData(_ weatherCurrent: WeatherCurrent) {
        nameCityLabel.text = weatherCurrent.nameCity
        temperatureLabel.text = weatherCurrent.temperatureInCelsius
        if let icon = weatherCurrent.weatherStatus {
            statusImageView.loadImage(withIcon: icon)
        }
        updateFavoriteButtonStatus(for: weatherCurrent.nameCity)
    }
    
    private func updateUIWithCoreData(_ weatherEntity: WeatherEntity) {
        nameCityLabel.text = weatherEntity.nameCity
        temperatureLabel.text = weatherEntity.temperature
        if let icon = weatherEntity.statusIcon {
            statusImageView.loadImage(withIcon: icon)
        }
    }
}
