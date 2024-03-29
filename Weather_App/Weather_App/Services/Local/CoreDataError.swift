//
//  CoreDataError.swift
//  Weather_App
//
//  Created by ho.bao.an on 25/03/2024.
//

import Foundation

enum CoreDataError: Error {
    case unresolvedError(NSError)
    case fetchFailed(String)
    case insertFailed(String)
    case deleteFailed(String)
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unresolvedError(let error):
            return "Core Data: Unresolved error \(error), \(error.userInfo)"
        case .fetchFailed(let message), .insertFailed(let message), .deleteFailed(let message):
            return "Core Data Error: \(message)"
        }
    }
}
