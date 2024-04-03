//
//  WeatherDetailViewController.swift
//  Weather_App
//
//  Created by ho.bao.an on 20/03/2024.
//

import UIKit
import Reusable

final class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let weatherDataStore = WeatherDataStore.shared
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let networkMonitor = NetworkMonitor.shared
    private var weatherCoreDataRepository: WeatherCoreDataRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        weatherCoreDataRepository = networkMonitor.isNetworkConnected()
                                                    ? OnlineWeatherDataService()
                                                    : OfflineWeatherDataService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension WeatherDetailViewController {
    private func configureTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.register(cellType: MainWeatherTableViewCell.self)
        tableView.register(cellType: DetailTableViewCell.self)
        tableView.register(cellType: ForecastTableViewCell.self)
    }
}

extension WeatherDetailViewController: UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        default:
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell : MainWeatherTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            configureCellContent(cell: cell)
            return cell
        case 1:
            let cell : DetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            configureCellContent(cell: cell)
            return cell
        default:
            let cell : ForecastTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}

extension WeatherDetailViewController {
    private func configureCellContent(cell: UITableViewCell) {
        guard let weatherEntities = weatherCoreDataRepository.getWeatherData() else {
            return
        }
        for weatherEntity in weatherEntities {
            if let mainWeatherCell = cell as? MainWeatherTableViewCell {
                mainWeatherCell.setContent(weatherEntity: weatherEntity)
            } else if let detailCell = cell as? DetailTableViewCell {
                detailCell.setContent(weatherEntity: weatherEntity)
            }
        }
    }
}
