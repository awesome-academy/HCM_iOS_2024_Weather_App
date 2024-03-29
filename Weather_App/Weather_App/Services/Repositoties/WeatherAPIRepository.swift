//
//  WeatherAPIRepository.swift
//  Weather_App
//
//  Created by ho.bao.an on 22/03/2024.
//

import Foundation

protocol WeatherRepository {
    func getWeatherCurrent(latMapKit: Double, lonMapKit: Double, completion: @escaping (Result<WeatherCurrent, Error>) -> Void)
    func getWeatherForecast(latMapKit: Double, lonMapKit: Double, completion: @escaping (Result<WeatherForecast, Error>) -> Void)
}

class WeatherAPIRepository: WeatherRepository {
    private let apiService: APIService
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    func getWeatherCurrent(latMapKit: Double, lonMapKit: Double, completion: @escaping (Result<WeatherCurrent, Error>) -> Void) {
        let urlString = "\(Urls.domain)/data/2.5/weather?lat=\(latMapKit)&lon=\(lonMapKit)&units=metric&appid=\(ApiKey.apiKey)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getWeatherForecast(latMapKit: Double, lonMapKit: Double, completion: @escaping (Result<WeatherForecast, Error>) -> Void) {
        let urlString = "\(Urls.domain)/data/2.5/forecast/daily?lat=\(latMapKit)&lon=\(lonMapKit)&cnt=7&units=metric&appid=\(ApiKey.apiKey)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
}
