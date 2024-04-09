//
//  ConvertDate.swift
//  Weather_App
//
//  Created by ho.bao.an on 02/04/2024.
//

import Foundation

enum DateFormat: String {
    case ddMMyy = "dd-MM-yyyy"
    case HHmm = "HH:mm"
    case ddMM = "dd-MM"
}

extension Date {
    static func dateFromTimestamp(_ timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func convertToDateString() -> String {
        return self.toString(format: .ddMMyy)
    }
    
    func convertToTimeString() -> String {
        return self.toString(format: .HHmm)
    }
    
    func convertToDayString() -> String {
        return self.toString(format: .ddMM)
    }
}
