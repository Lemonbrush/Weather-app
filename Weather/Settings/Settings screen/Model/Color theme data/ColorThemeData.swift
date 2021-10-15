//
//  ColorThemeData.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import Foundation

struct ColorThemeData: Codable {
    let title: String
    let clear_sky: Colors
    let few_clouds: Colors
    let scattered_clouds: Colors
    let broken_clouds: Colors
    let shower_rain: Colors
    let rain: Colors
    let thunderstorm: Colors
    let snow: Colors
    let mist: Colors
    let backgroundColors: BackgroundColors
    let detailReviewIconsColors: DetailReviewIconsColors
}

struct Colors: Codable {
    let colors: [String]
    let iconColors: String
    let labelsColor: String
}

struct BackgroundColors: Codable {
    let colors: [String]
    let ignoreColorInheritance: Bool
}

struct DetailReviewIconsColors: Codable {
    let cloud: String
    let sun: String
    let humidity: String
    let uvIndex: String
    let wind: String
    let cloudiness: String
    let pressure: String
    let visibility: String
}
