//
//  WeatherData.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

//Data struct for JSON decoding
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}
