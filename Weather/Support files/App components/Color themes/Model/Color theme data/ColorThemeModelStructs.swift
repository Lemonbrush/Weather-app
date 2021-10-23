//
//  ColorThemeModelStructs.swift
//  Weather
//
//  Created by Alexander Rubtsov on 20.10.2021.
//

import UIKit

struct ColorThemeColorsModel {
    let colors: [UIColor]
    let iconsColor: UIColor
    let labelsColor: UIColor
}

struct IconColorsColorThemeModel {
    let mist: UIColor
    let snow: UIColor
    let rain: UIColor
    let showerRain: UIColor
    let thunderstorm: UIColor
    let cloud: UIColor
    let sun: UIColor
    let humidity: UIColor
    let uvIndex: UIColor
    let wind: UIColor
    let cloudiness: UIColor
    let pressure: UIColor
    let visibility: UIColor
}

struct MainMenuColorThemeModel {
    let backgroundColor: UIColor
    let dateLabelColor: UIColor
    let todayColor: UIColor
    let settingsIconColor: UIColor
    let searchButtonColor: UIColor
    let cells: CellsColorThemeModel
}

struct CellsColorThemeModel {
    let isShadowVisible: Bool
    let gradient: GradientColorThemeModel
    var clearSky: ColorThemeColorsModel
    var fewClouds: ColorThemeColorsModel
    var scatteredClouds: ColorThemeColorsModel
    var brokenClouds: ColorThemeColorsModel
    var showerRain: ColorThemeColorsModel
    var rain: ColorThemeColorsModel
    var thunderstorm: ColorThemeColorsModel
    var snow: ColorThemeColorsModel
    var mist: ColorThemeColorsModel
}

struct BackgroundColorColorThemeModel {
    let backgroundColor: UIColor
    let isClearBackground: Bool
    let isShadowVisible: Bool
    let labelsColor: UIColor
    let labelsSecondaryColor: UIColor
}

struct ContentBackgroundColorTheme {
    let color: UIColor
    let isClearBackground: Bool
}

struct ScreenBackgroundColorThemeModel {
    let colors: [UIColor]
    let gradient: GradientColorThemeModel
    let mainIconColor: UIColor
    let labelsColor: UIColor
    let labelsSecondaryColor: UIColor
    let ignoreColorInheritance: Bool
}

struct CityDetailsColorThemeModel {
    let hourlyForecast: BackgroundColorColorThemeModel
    let weeklyForecast: BackgroundColorColorThemeModel
    let weatherQuality: BackgroundColorColorThemeModel
    let contentBackground: ContentBackgroundColorTheme
    let screenBackground: ScreenBackgroundColorThemeModel
    let iconColors: IconColorsColorThemeModel
}

struct GradientColorThemeModel {
    let startPoint: CGPoint
    let endPoint: CGPoint
}

struct SettingsScreenColorTheme {
    let colorBoxesColors: [UIColor]
}
