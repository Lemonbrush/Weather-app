//
//  WeatherData.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

//Data struct for JSON decoding
struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let sys: Sys
    let timezone: Int
    let name: String
}

struct Sys: Codable {
    let country: String
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

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
