//
//  MainWeatherTableViewCell.swift
//  Weather_App
//
//  Created by ho.bao.an on 29/03/2024.
//

import UIKit
import Reusable

final class MainWeatherTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        cellView.layer.cornerRadius = Constants.cornerRadius
        cellView.addShadow()
        statusView.layer.cornerRadius = Constants.cornerRadius
        statusView.addShadow()
        self.selectionStyle = .none
    }
}

extension MainWeatherTableViewCell {
    func setContent(weatherEntity: WeatherEntity) {
        nameCityLabel.text = weatherEntity.nameCity
        dateTimeLabel.text = weatherEntity.dateTime
        statusLabel.text = weatherEntity.descriptionStatus
        temperatureLabel.text = weatherEntity.temperature
        if let icon = weatherEntity.statusIcon {
            statusImage.loadImage(withIcon: icon)
        } else {
            statusImage.image = UIImage.wifiSlashImage()
        }
    }
}
