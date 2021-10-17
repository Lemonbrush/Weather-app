//
//  ColorThemeModel.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

struct ColorThemeColorsModel {
    let colors: [UIColor]
    let iconsColor: UIColor
    let labelsColor: UIColor
}

struct IconColorsColorThemeModel {
    let cloud: UIColor
    let sun: UIColor
    let humidity: UIColor
    let uvIndex: UIColor
    let wind: UIColor
    let cloudiness: UIColor
    let pressure: UIColor
    let visibility: UIColor
}

struct BackgroundColorsColorThemeModel {
    let colors: [UIColor]
    let gradient: GradientColorThemeModel
    let mainIconColor: UIColor
    let mainLabelsColor: UIColor
    let ignoreColorInheritance: Bool
}

struct MainMenuColorThemeModel {
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

struct CityDetailsColorThemeModel {
    let background: BackgroundColorsColorThemeModel
    let iconColors: IconColorsColorThemeModel
}

struct GradientColorThemeModel {
    let startPoint: CGPoint
    let endPoint: CGPoint
}

struct ColorThemeModel {
    
    // MARK: - Private properties
    
    private let rawColorThemeDataModel: ColorThemeData
    
    // MARK: - Public properties
    
    var title: String {
        rawColorThemeDataModel.title
    }
    
    var mainMenu: MainMenuColorThemeModel {
        let mainMenu = rawColorThemeDataModel.mainMenu
        let mainMenuGradient = GradientColorThemeModel(startPoint: CGPoint(x: mainMenu.gradient.startPoint.x, y: mainMenu.gradient.startPoint.y),
                                                       endPoint: CGPoint(x: mainMenu.gradient.endPoint.x, y: mainMenu.gradient.endPoint.y))
        return MainMenuColorThemeModel(gradient: mainMenuGradient,
                                       clearSky: convertToColorThemeModel(colorsModel: mainMenu.clear_sky),
                                       fewClouds: convertToColorThemeModel(colorsModel: mainMenu.few_clouds),
                                       scatteredClouds: convertToColorThemeModel(colorsModel: mainMenu.scattered_clouds),
                                       brokenClouds: convertToColorThemeModel(colorsModel: mainMenu.broken_clouds),
                                       showerRain: convertToColorThemeModel(colorsModel: mainMenu.shower_rain),
                                       rain: convertToColorThemeModel(colorsModel: mainMenu.rain),
                                       thunderstorm: convertToColorThemeModel(colorsModel: mainMenu.thunderstorm),
                                       snow: convertToColorThemeModel(colorsModel: mainMenu.snow),
                                       mist: convertToColorThemeModel(colorsModel: mainMenu.mist))
    }
    
    var cityDetails: CityDetailsColorThemeModel {
        let cityDetails = rawColorThemeDataModel.cityDetails
        let backgroundRawGradient = cityDetails.background.gradient
        let backgroundGradient = GradientColorThemeModel(startPoint: CGPoint(x: backgroundRawGradient.startPoint.x, y: backgroundRawGradient.startPoint.y),
                                                         endPoint: CGPoint(x: backgroundRawGradient.endPoint.x, y: backgroundRawGradient.endPoint.y))
        let background = BackgroundColorsColorThemeModel(colors: makeColors(hexes: cityDetails.background.colors),
                                                         gradient: backgroundGradient,
                                                         mainIconColor: makeColor(hex: cityDetails.background.mainIconColor),
                                                         mainLabelsColor: makeColor(hex: cityDetails.background.mainLabelsColor),
                                                         ignoreColorInheritance: cityDetails.background.ignoreColorInheritance)
        let iconColors = IconColorsColorThemeModel(cloud: makeColor(hex: cityDetails.iconColors.cloud),
                                                   sun: makeColor(hex: cityDetails.iconColors.sun),
                                                   humidity: makeColor(hex: cityDetails.iconColors.humidity),
                                                   uvIndex: makeColor(hex: cityDetails.iconColors.uvIndex),
                                                   wind: makeColor(hex: cityDetails.iconColors.wind),
                                                   cloudiness: makeColor(hex: cityDetails.iconColors.cloudiness),
                                                   pressure: makeColor(hex: cityDetails.iconColors.pressure),
                                                   visibility: makeColor(hex: cityDetails.iconColors.visibility))
        return CityDetailsColorThemeModel(background: background,
                                          iconColors: iconColors)
    }
    
    // MARK: - Construction
    
    init() {
        let black = "#000000"
        let white = "#ffffff"
        let defaultColors = Colors(colors: [white],
                                  iconColors: black,
                                  labelsColor: black)
        let defaultGradient = Gradient(startPoint: StartPoint(x: 0.0,
                                                              y: 0.0),
                                       endPoint: EndPoint(x: 0.0,
                                                          y: 0.0))
        let defaultMainMenu = MainMenu(gradient: defaultGradient,
                                       clear_sky: defaultColors,
                                       few_clouds: defaultColors,
                                       scattered_clouds: defaultColors,
                                       broken_clouds: defaultColors,
                                       shower_rain: defaultColors,
                                       rain: defaultColors,
                                       thunderstorm: defaultColors,
                                       snow: defaultColors,
                                       mist: defaultColors)
        let defaultBackground = Background(colors: [white],
                                           gradient: defaultGradient,
                                           mainIconColor: black,
                                           mainLabelsColor: black,
                                           ignoreColorInheritance: false)
        let defaultIconColors = IconColors(cloud: black,
                                           sun: black,
                                           humidity: black,
                                           uvIndex: black,
                                           wind: black,
                                           cloudiness: black,
                                           pressure: black,
                                           visibility: black)
        let defaultCityDetails = CityDetails(background: defaultBackground,
                                             iconColors: defaultIconColors)
        rawColorThemeDataModel = ColorThemeData(title: "Default",
                                                mainMenu: defaultMainMenu,
                                                cityDetails: defaultCityDetails)
    }
    
    init(colorThemeData: ColorThemeData) {
        rawColorThemeDataModel = colorThemeData
    }
    
    // MARK: - Functions
    
    func getColorByConditionId(_ conditionId: Int) -> ColorThemeColorsModel {
        switch conditionId {
        case 200...232:
            return mainMenu.thunderstorm
        case 300...321:
            return mainMenu.rain
        case 500...531:
            return mainMenu.showerRain
        case 600...622:
            return mainMenu.snow
        case 701...781:
            return mainMenu.mist
        case 800:
            return mainMenu.clearSky
        case 801...804:
            return mainMenu.scatteredClouds
        default:
            return mainMenu.clearSky
        }
    }
    
    func getDetailReviewIconColorByConditionId(_ conditionId: Int) -> UIColor {
        switch conditionId {
        case 800:
            return cityDetails.iconColors.sun
        default:
            return cityDetails.iconColors.cloud
        }
    }
    
    static func convertUiColorsToCg(_ uiColors: [UIColor]) -> [CGColor] {
        var cgColors: [CGColor] = []
        for uiColor in uiColors {
            cgColors.append(uiColor.cgColor)
        }
        return cgColors
    }
    
    // MARK: - Private functions
    
    private func convertToColorThemeModel(colorsModel: Colors) -> ColorThemeColorsModel {
        return ColorThemeColorsModel(colors: makeColors(hexes: colorsModel.colors),
                                     iconsColor: makeColor(hex: colorsModel.iconColors),
                                     labelsColor: makeColor(hex: colorsModel.labelsColor))
    }
    
    private func makeColors(hexes: [String]) -> [UIColor] {
        var colors: [UIColor] = []
        for colorHex in hexes {
            colors.append(makeColor(hex: colorHex))
        }
        return colors
    }
    
    private func makeColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
