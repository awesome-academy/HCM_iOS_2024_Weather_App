//
//  ForecastCollectionViewCell.swift
//  Weather_App
//
//  Created by An Bảo on 31/03/2024.
//

import UIKit
import Reusable

final class ForecastCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    override func prepareForReuse() {
        dateTimeLabel.text = ""
        temperatureLabel.text = ""
        statusLabel.text = ""
        statusImage.image = nil
    }
    
    private func setupUI() {
        statusView.layer.cornerRadius = Constants.cornerRadius
        statusView.addShadow()
    }
}

extension ForecastCollectionViewCell {
    func setContent(weatherDataEntity: WeatherDataEntity) {
        dateTimeLabel.text = weatherDataEntity.date
        statusLabel.text = weatherDataEntity.descriptionStatus
        temperatureLabel.text = weatherDataEntity.temperature
        if let icon = weatherDataEntity.statusIcon {
            statusImage.loadImage(withIcon: icon)
        } else {
            statusImage.image = UIImage.wifiSlashImage()
        }
    }
}
