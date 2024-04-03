//
//  StringtoDate.swift
//  Weather_App
//
//  Created by ho.bao.an on 09/04/2024.
//

import Foundation

extension String {
    func toDate(format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
