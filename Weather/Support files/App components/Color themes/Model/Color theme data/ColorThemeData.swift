//
//  ColorThemeData.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import Foundation

struct ColorThemeData: Codable {
    let title: String
    let settingsScreen: SettingsScreen
    let mainMenu: MainMenu
    let addCity: AddCity
    let cityDetails: CityDetails
}

// MARK: - Settings screen

struct SettingsScreen: Codable {
    let backgroundColor: String
    let cellsBackgroundColor: String
    let labelsColor: String
    let labelsSecondaryColor: String
    let appIconSelectBorderColor: String
    let appIconDeselectBorderColor: String
    let temperatureSwitchColor: String
    let colorBoxesColors: [String]
}

// MARK: - AddCity screen

struct AddCity: Codable {
    let backgroundColor: String
    let searchFieldBackground: String
    let cancelButtonColor: String
    let placeholderColor: String
    let handleColor: String
    let isShadowVisible: Bool
    let labelsColor: String
    let labelsSecondaryColor: String
}

// MARK: - Main menu

struct MainMenu: Codable {
    let isStatusBarDark: Bool
    let backgroundColor: String
    let dateLabelColor: String
    let todayColor: String
    let settingsIconColor: String
    let searchButtonColor: String
    let cells: Cells
}

struct Cells: Codable {
    let isShadowVisible: Bool
    let gradient: Gradient
    let defaultBackground: String
    let defaultLoadingViewsColor: String
    let activityViewColor: String
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

// MARK: - City details

struct CityDetails: Codable {
    let isNavBarDark: Bool
    let isStatusBarDark: Bool
    let hourlyForecast: BackgroundColor
    let weeklyForecast: BackgroundColor
    let weatherQuality: BackgroundColor
    let contentBackground: ContentBackground
    let screenBackground: ScreenBackground
    let iconColors: IconColors
}

struct ContentBackground: Codable {
    let color: String
    let isClearBackground: Bool
}

struct BackgroundColor: Codable {
    let backgroundColor: String
    let isClearBackground: Bool
    let isShadowVisible: Bool
    let labelsColor: String
    let labelsSecondaryColor: String
}

struct ScreenBackground: Codable {
    let colors: [String]
    let gradient: Gradient
    let mainIconColor: String
    let labelsColor: String
    let labelsSecondaryColor: String
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
