//
//  WeatherData.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

// Data struct for JSON decoding
struct WeatherData: Codable {
    let lat: Double
    let lon: Double
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
    let uvi: Double

    let clouds: Int // Cloudiness, %
    let visibility: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

// MARK: - Hourly

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

// MARK: - Daily

struct Daily: Codable {
    let dt: Int

    let sunrise: Int
    let sunset: Int
    let temp: Temp
    let feels_like: Feels_like
    let weather: [Weather]
    let pop: Double
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
