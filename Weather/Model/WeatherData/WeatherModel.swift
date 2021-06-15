//
//  WeatherModel.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

struct WeatherModel {
    
    let lat: Double
    let lon: Double
    
    let conditionId: Int
    var cityName: String
    let temperature: Double
    let timezone: Int
    let feelsLike: Double
    let description: String
    
    let humidity: Int
    let uviIndex: Double
    let wind: Double
    let cloudiness: Int
    let pressure: Int
    let visibility: Int
    
    let daily: [Daily]
    let hourly: [Hourly]
    
    var cityRequest: SavedCity {
        return SavedCity(name: cityName, latitude: lat, longitude: lon)
    }
    
    var humidityString: String {
        String("\(humidity)%")
    }
    
    var windString: String {
        String("\(wind) m/s")
    }
    
    var cloudinessString: String {
        String("\(cloudiness)%")
    }
    
    var pressureString: String {
        String("\(pressure) hPa")
    }
    
    var visibilityString: String {
        String("\(visibility) m.")
    }
    
    var feelsLikeString: String {
        String(format: "Feels like %.0f°", feelsLike)
    }
    
    var temperatureString: String {
        String(format: "%.0f°", temperature)
    }
    
    static func getcConditionNameBy(conditionId id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "error"
        }
    }
}
