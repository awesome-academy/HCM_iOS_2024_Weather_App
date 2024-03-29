//
//  HeaderCollectionReusableView.swift
//  Weather_App
//
//  Created by ho.bao.an on 01/04/2024.
//

import UIKit
import Reusable

final class HeaderCollectionReusableView: UICollectionReusableView, Reusable {
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width, height: 60))
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(label)
    }
}
