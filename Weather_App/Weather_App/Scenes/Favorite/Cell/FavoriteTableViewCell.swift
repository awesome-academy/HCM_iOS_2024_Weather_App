//
//  FavoriteTableViewCell.swift
//  Weather_App
//
//  Created by ho.bao.an on 09/04/2024.
//

import UIKit
import Reusable

class FavoriteTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var namCityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeUpdateLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }
}

extension FavoriteTableViewCell {
    func setContent(weatherEntity: WeatherEntity) {
        namCityLabel.text = weatherEntity.nameCity
        descriptionLabel.text = weatherEntity.descriptionStatus
        temperatureLabel.text = weatherEntity.temperature
        guard let dateTime = weatherEntity.dateTime else {
            timeUpdateLabel.text = "Last update: N/A"
            return
        }
        timeUpdateLabel.text = "Last update: \(dateTime)"
        if let icon = weatherEntity.statusIcon {
            statusImage.loadImage(withIcon: icon)
        } else {
            statusImage.image = UIImage.wifiSlashImage()
        }
    }
}
