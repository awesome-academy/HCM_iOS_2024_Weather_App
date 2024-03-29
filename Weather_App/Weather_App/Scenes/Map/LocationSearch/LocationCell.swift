//
//  LocationCell.swift
//  Weather_App
//
//  Created by ho.bao.an on 28/03/2024.
//

import UIKit
import Reusable

final class LocationCell : UITableViewCell, Reusable {
    
    func setContent(name: String) {
        textLabel?.text = name
    }
    
}
