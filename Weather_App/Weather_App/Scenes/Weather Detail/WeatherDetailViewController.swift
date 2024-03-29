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
    
    private var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
    }
}

extension WeatherDetailViewController {
    private func setupUI() {
        navigationItem.searchController = searchController
        customizeNavigationController()
        customizeSearchController(searchController: searchController)
    }
    
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
            return cell
        case 1:
            let cell : DetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            let cell : ForecastTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
