//
//  DetailTableViewCell.swift
//  Weather_App
//
//  Created by ho.bao.an on 29/03/2024.
//

import UIKit
import Reusable

final class DetailTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
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
    }
}

extension DetailTableViewCell {
    func setContent(weatherEntity: WeatherEntity) {
        cloudsLabel.text = weatherEntity.clouds
        windLabel.text = weatherEntity.wind
        humidityLabel.text = weatherEntity.humidity
        sunriseTimeLabel.text = weatherEntity.sunrise
        sunsetTimeLabel.text = weatherEntity.sunset
    }
}
