//
//  WeatherModel.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let timezone: Int
    
    var weatherTemperatureString: String {
        String(format: "%.0f°", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud"
        default:
            return "error"
        }
    }
}
