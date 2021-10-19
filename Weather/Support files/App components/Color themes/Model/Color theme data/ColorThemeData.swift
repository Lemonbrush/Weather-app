//
//  ColorThemeData.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import Foundation

struct ColorThemeData: Codable {
    let title: String
    let mainMenu: MainMenu
    let cityDetails: CityDetails
}

// Main menu

struct MainMenu: Codable {
    let gradient: Gradient
    let clear_sky: Colors
    let few_clouds: Colors
    let scattered_clouds: Colors
    let broken_clouds: Colors
    let shower_rain: Colors
    let rain: Colors
    let thunderstorm: Colors
    let snow: Colors
    let mist: Colors
}

struct Colors: Codable {
    let colors: [String]
    let iconColors: String
    let labelsColor: String
}

struct Gradient: Codable {
    let startPoint: StartPoint
    let endPoint: EndPoint
}

struct StartPoint: Codable {
    let x: Double
    let y: Double
}

struct EndPoint: Codable {
    let x: Double
    let y: Double
}

// City details

struct CityDetails: Codable {
    let background: Background
    let iconColors: IconColors
}

struct Background: Codable {
    let colors: [String]
    let gradient: Gradient
    let mainIconColor: String
    let mainLabelsColor: String
    let ignoreColorInheritance: Bool
}

struct IconColors: Codable {
    let mist: String
    let snow: String
    let rain: String
    let showerRain: String
    let thunderstorm: String
    let cloud: String
    let sun: String
    let humidity: String
    let uvIndex: String
    let wind: String
    let cloudiness: String
    let pressure: String
    let visibility: String
}
