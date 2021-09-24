//
//  ColorThemeData.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import Foundation

struct ColorThemesData: Codable {
    let title: String
    let clear_sky: [String]
    let few_clouds: [String]
    let scattered_clouds: [String]
    let broken_clouds: [String]
    let shower_rain: [String]
    let rain: [String]
    let thunderstorm: [String]
    let snow: [String]
    let mist: [String]
}
