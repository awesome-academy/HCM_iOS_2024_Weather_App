//
//  NetworkError.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}
