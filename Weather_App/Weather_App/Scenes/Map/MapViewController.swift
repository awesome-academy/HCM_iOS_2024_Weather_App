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
    private let cornerRadius = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension MapViewController {
    func setUpUI() {
        informationWeatherView.layer.cornerRadius = cornerRadius
        informationWeatherView.addShadow()
        statusView.layer.cornerRadius = cornerRadius
        statusView.addShadow()
        navigationItem.searchController = searchController
        customizeNavigationController()
        customizeSearchController(searchController: searchController)
    }
}

