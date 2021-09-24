//
//  ColorThemeModel.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

struct ColorThemeModel {
    
    // MARK: - Private properties
    
    private let clearSkyHexes: [String]
    private let fewCloudsHexes: [String]
    private let scatteredCloudsHexes: [String]
    private let brokenCloudsHexes: [String]
    private let showerRainHexes: [String]
    private let rainHexes: [String]
    private let thunderstormHexes: [String]
    private let snowHexes: [String]
    private let mistHexes: [String]
    
    // MARK: - Public properties
    
    let title: String
    
    var clearSky: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in clearSkyHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var fewClouds: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in fewCloudsHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var scatteredClouds: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in scatteredCloudsHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var brokenClouds: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in brokenCloudsHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var showerRain: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in showerRainHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var rain: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in rainHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var thunderstorm: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in thunderstormHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var snow: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in snowHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    var mist: [UIColor] {
        var colors: [UIColor] = []
        for colorHex in mistHexes {
            colors.append(makeColor(hex: colorHex))
        }
        
        return colors
    }
    
    // MARK: - Construction
    
    init(title: String,
         clearSky: [String],
         fewClouds: [String],
         scatteredClouds: [String],
         brokenClouds: [String],
         showerRain: [String],
         rain: [String],
         thunderstorm: [String],
         snow: [String],
         mist: [String]) {
        self.title = title
        clearSkyHexes = clearSky
        fewCloudsHexes = fewClouds
        scatteredCloudsHexes = scatteredClouds
        brokenCloudsHexes = brokenClouds
        showerRainHexes = showerRain
        rainHexes = rain
        thunderstormHexes = thunderstorm
        snowHexes = snow
        mistHexes = mist
    }
    
    // MARK: - Private functions
    
    private func makeColor(hex:String) -> UIColor {
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
