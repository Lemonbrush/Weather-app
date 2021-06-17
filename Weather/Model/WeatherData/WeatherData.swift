//
//  WeatherData.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

//Data struct for JSON decoding
struct WeatherData: Codable {
    let lat: Double
    let lon: Double
    //let timezone: String // (America/Chicago)
    let timezone_offset: Int
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

// MARK: - Current

struct Current: Codable {
    let dt: Int // Current time
    
    let sunrise: Int
    let sunset: Int
    
    let temp: Double
    let feels_like: Double
    
    let pressure: Int
    let humidity: Int
    //let dew_point: Double // Atmospheric temperature
    let uvi: Double
    
    let clouds: Int // Cloudiness, %
    let visibility: Int
    let wind_speed: Double
    //let wind_deg: Int // Wind direction, degrees (meteorological)
    //let wind_gust: Double?
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    //let icon: String // Local API icon image name
}

// MARK: - Hourly

struct Hourly: Codable {
    let dt: Int
    
    let temp: Double
    //let feels_like: Double
    
    //let pressure: Int
    //let humidity: Int
    //let dew_point: Double
    //let uvi: Double
    //let clouds: Int
    //let visibility: Int
    //let wind_speed: Double
    //let wind_deg: Int
    //let wind_gust: Double
    
    let weather: [Weather]
    
    //let pop: Double // Probability of precipitation
}

// MARK: - Daily

struct Daily: Codable {
    let dt: Int
    
    let sunrise: Int
    let sunset: Int
    
    //let moonrise: Int
    //let moonset: Int
    //let moon_phase: Double
    let temp: Temp
    let feels_like: Feels_like
    //let pressure: Int
    //let humidity: Int
    //let dew_point: Double
    //let wind_speed: Double
    //let wind_deg: Int
    //let wind_gust: Double?
    let weather: [Weather]
    //let clouds: Int
    let pop: Double
    //let rain: Double?
    //let uvi: Double
}

struct Temp: Codable {
    let day: Double // Day temperature
    let min: Double // Min daily temperature
    let max: Double // Max daily temperature
    let night: Double // Night temperature
    let eve: Double // Evening temperature
    let morn: Double // Morning temperature
}

struct Feels_like: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
