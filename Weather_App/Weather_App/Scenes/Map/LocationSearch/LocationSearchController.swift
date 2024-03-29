//
//  LocationSearchController.swift
//  Weather_App
//
//  Created by ho.bao.an on 28/03/2024.
//

import UIKit
import MapKit

protocol LocationSearchDelegate: AnyObject {
    func didSelectLocation(name: String, coordinate: CLLocationCoordinate2D)
}

final class LocationSearchController: UITableViewController {
    
    private var searchResults: [MKMapItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: LocationSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        tableView.register(LocationCell.self, forCellReuseIdentifier: "LocationCell")
    }
    
}

extension LocationSearchController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchResults.removeAll()
            return
        }
        LocationSearchRepository.getSearchResults(for: searchText) { [weak self] mapItems, error in
            guard let self = self else { return }
            if let error = error {
                return
            }
            if let mapItems = mapItems {
                if mapItems.isEmpty {
                    self.presentErrorAlert(title: "ERROR", message: "Location not found")
                }
                self.searchResults = mapItems
            }
        }
    }
}

extension LocationSearchController {
    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let mapItem = searchResults[indexPath.row].placemark
        let name = mapItem.name ?? "Unknown"
        cell.setContent(name: name)
        return cell
    }
}

extension LocationSearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMapItem = searchResults[indexPath.row]
        let selectedPlacemark = selectedMapItem.placemark
        let coordinate = selectedPlacemark.coordinate
        let name = selectedPlacemark.name ?? "Unknown"
        delegate?.didSelectLocation(name: name, coordinate: coordinate)
    }
}
