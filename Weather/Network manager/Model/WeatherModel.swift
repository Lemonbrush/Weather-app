//
//  WeatherModel.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

//Enum for different types of collectionView cells
enum SunStateDescription {
    case sunset
    case sunrise
}

struct SunState {
    let description: SunStateDescription
    let dt: Int
}

enum HourlyDataType {
    case weatherType(Hourly)
    case sunState(SunState)
}

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
    
    let sunrise: Int
    let sunset: Int
    
    let daily: [Daily]
    let hourly: [Hourly]
    
    var hourlyDisplayData: [HourlyDataType] {
        var hourlyDataMix = [HourlyDataType]()
        
        //SunType cells data for sunset/sunrise for the current day and the next one
        var sunStates = [SunState(description: .sunrise, dt: sunrise),
                         SunState(description: .sunset, dt: sunset),
                         SunState(description: .sunrise, dt: daily[1].sunrise),
                         SunState(description: .sunset, dt: daily[1].sunset)]
        
        for i in 0...24  {
            let currentHour = hourly[i]
            
            //Add SunType cell data
            for (i, sunState) in sunStates.enumerated() {
                //Check the next hour syntetically
                //Add sunType cell data after current time cell and before the next time cell
                if sunState.dt < currentHour.dt &&  sunState.dt > Int(Date().timeIntervalSince1970) {
                    hourlyDataMix.append(HourlyDataType.sunState(SunState(description: sunState.description, dt: sunState.dt)))
                    sunStates.remove(at: i)
                }
            }
            
            //Add weather cell data
            let currentTemp = HourlyDataType.weatherType(currentHour)
            hourlyDataMix.append(currentTemp)
        }
        
        return hourlyDataMix
    }
    
    var cityRequest: SavedCity {
        return SavedCity(name: cityName, latitude: lat, longitude: lon)
    }
    
    //Strings
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
    
    static func getConditionNameBy(conditionId id: Int) -> String {
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
