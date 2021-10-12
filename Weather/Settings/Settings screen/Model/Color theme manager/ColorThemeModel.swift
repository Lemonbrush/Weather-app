//
//  ColorThemeModel.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

struct ColorThemeColorsModel {
    let colors: [UIColor]
    let iconColors: UIColor
}

struct ColorThemeModel {
    
    // MARK: - Private properties
    
    private let rowColorThemeDataModel: ColorThemeData
    
    // MARK: - Public properties
    
    var title: String {
        rowColorThemeDataModel.title
    }
    
    var clearSky: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.clear_sky)
    }
    
    var fewClouds: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.few_clouds)
    }
    
    var scatteredClouds: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.scattered_clouds)
    }
    
    var brokenClouds: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.broken_clouds)
    }
    
    var showerRain: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.shower_rain)
    }
    
    var rain: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.rain)
    }
    
    var thunderstorm: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.thunderstorm)
    }
    
    var snow: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.snow)
    }
    
    var mist: ColorThemeColorsModel {
        convertToColorThemeModel(colorsModel: rowColorThemeDataModel.mist)
    }
    
    var backgroundColors: [UIColor] {
        makeColors(hexes: rowColorThemeDataModel.backgroundColors)
    }
    
    // MARK: - Construction
    
    init(colorThemeData: ColorThemeData) {
        rowColorThemeDataModel = colorThemeData
    }
    
    // MARK: - Private functions
    
    private func convertToColorThemeModel(colorsModel: Colors) -> ColorThemeColorsModel {
        return ColorThemeColorsModel(colors: makeColors(hexes: colorsModel.colors),
                                     iconColors: makeColor(hex: colorsModel.iconColors))
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
