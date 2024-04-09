//
//  FavoriteViewController.swift
//  Weather_App
//
//  Created by ho.bao.an on 20/03/2024.
//

import UIKit

final class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let coordinateStored = CoordinateStored.shared
    private var weatherEntities: [WeatherEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func loadData() {
        weatherCurrentCoreDataManager.fetchWeatherEntitiesWithSaveStatus { [weak self] (weatherEntities, error) in
            guard let self = self, error == nil, let weatherEntities = weatherEntities else {
                if let error = error {
                    print("Error fetching weather entities with save status true: \(error)")
                }
                return
            }
            self.weatherEntities = weatherEntities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension FavoriteViewController : UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weatherEntities = weatherEntities {
            return weatherEntities.count
        } else {
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FavoriteTableViewCell.self)
        configureCellContent(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteEntity(at: indexPath)
        default:
            break
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let weatherEntities = weatherEntities, indexPath.row < weatherEntities.count else {
            return
        }
        let selectedWeatherEntity = weatherEntities[indexPath.row]
        coordinateStored.setCoordinates(latitude: selectedWeatherEntity.latitude, longitude: selectedWeatherEntity.longitude)
        tabBarController?.selectedIndex = 0
    }
}

extension FavoriteViewController {
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: FavoriteTableViewCell.self)
    }
    
    private func configureCellContent(cell: FavoriteTableViewCell, indexPath: IndexPath) {
        guard let weatherEntities = weatherEntities, indexPath.row < weatherEntities.count else {
            return
        }
        let weatherEntity = weatherEntities[indexPath.row]
        cell.setContent(weatherEntity: weatherEntity)
    }
    
    private func deleteEntity(at indexPath: IndexPath) {
        guard let weatherEntities = weatherEntities, indexPath.row < weatherEntities.count else {
            return
        }
        let weatherEntityToDelete = weatherEntities[indexPath.row]
        weatherCurrentCoreDataManager.deleteWeatherFromCoreData(weatherEntity: weatherEntityToDelete) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error deleting weather entity: \(error)")
                return
            }
            self.weatherEntities?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
