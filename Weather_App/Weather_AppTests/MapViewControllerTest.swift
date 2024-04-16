//
//  MapViewControllerTest.swift
//  Weather_AppTests
//
//  Created by An Bảo on 16/04/2024.
//

import XCTest
@testable import Weather_App
import MapKit

final class MapViewControllerTest: XCTestCase {
    
    var mapViewController: MapViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mapViewController = storyboard.instantiateViewController(
            withIdentifier: "MapViewController") as? MapViewController
        mapViewController.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        mapViewController = nil
        try super.tearDownWithError()
    }
    
    func testSetUpUI() {
        mapViewController.setUpUI()
        XCTAssertEqual(mapViewController.informationWeatherView.layer.cornerRadius, Constants.cornerRadius)
        XCTAssertEqual(mapViewController.statusView.layer.cornerRadius, Constants.cornerRadius)
    }
    
    func testFetchCurrentWeather() {
        let expectation = XCTestExpectation(description: "Fetch current weather")
        mapViewController.fetchCurrentWeather(latitude: 0.0, longitude: 0.0) { weatherCurrent in
            XCTAssertNotNil(weatherCurrent)
            expectation.fulfill()
        }
    }
    
    func testFetchForecastWeather() {
        let expectation = XCTestExpectation(description: "Fetch forecast weather")
        mapViewController.fetchForecastWeather(latitude: 0.0, longitude: 0.0) { weatherForecast in
            XCTAssertNotNil(weatherForecast)
            expectation.fulfill()
        }
    }
    
    func testFavoriteButtonTogglesState() {
        XCTAssertFalse(mapViewController.isFavorite)
        mapViewController.favoriteButtonTapped(self)
        XCTAssertTrue(mapViewController.isFavorite)
        mapViewController.favoriteButtonTapped(self)
        XCTAssertFalse(mapViewController.isFavorite)
    }
    
    func testDidSelectLocationWithValidInput() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let locationName = "San Francisco"
        mapViewController.didSelectLocation(name: locationName, coordinate: coordinate)
        XCTAssertEqual(mapViewController.mapView.annotations.count, 1)
        XCTAssertEqual(mapViewController.mapView.annotations.first?.coordinate.latitude, coordinate.latitude)
        XCTAssertEqual(mapViewController.mapView.annotations.first?.coordinate.longitude, coordinate.longitude)
        XCTAssertEqual(mapViewController.mapView.annotations.first?.title, locationName)
    }
}

