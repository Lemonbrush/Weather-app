//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Александр on 20.06.2021.
//

import Foundation

struct UserDefaultsManager {
    static func getUnitData() -> String? {
        return UserDefaults.standard.string(forKey: K.UserDefaults.unit)
    }

    static func setUnitData(with unit: String) {
        if unit == K.UserDefaults.imperial || unit == K.UserDefaults.metric {
            UserDefaults.standard.setValue(unit, forKey: K.UserDefaults.unit)
        }
    }
    
    struct ColorTheme {
        static func getCurrentColorThemeNumber() -> Int {
            return UserDefaults.standard.integer(forKey: K.UserDefaults.colorThemePositionNumber)
        }

        static func setChosenPositionColorTheme(with position: Int) {
            UserDefaults.standard.setValue(position, forKey: K.UserDefaults.colorThemePositionNumber)
        }
        
        static func getColorTheme(_ num: Int) -> ColorThemeModel {
            guard let colorThemes = ColorThemeManager.getColorThemes(),
                  colorThemes.count >= num else {
                return ColorThemeModel()
            }
            
            return colorThemes[num]
        }
        
        static func getCurrentColorTheme() -> ColorThemeModel {
            let currentColorThemeNumber = self.getCurrentColorThemeNumber()
            
            guard let colorThemes = ColorThemeManager.getColorThemes(),
                  currentColorThemeNumber < colorThemes.count else {
                return ColorThemeModel()
            }
            
            return colorThemes[currentColorThemeNumber]
        }
    }
}
