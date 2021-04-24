//
//  WeatherData.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

//Data struct for JSON decoding
struct WeatherDataBundle: Codable {
    let cnt: Int
    let list: [WeatherList]
}

struct WeatherList: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: WeatherSys
}

struct WeatherSys: Codable {
    let country: String
    let timezone: Int
    //TODO: add more here
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}
