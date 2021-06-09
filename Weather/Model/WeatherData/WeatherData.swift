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
    let timezone_offset: Int
    let current: Current
}

struct Current: Codable {
    let temp: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
}
