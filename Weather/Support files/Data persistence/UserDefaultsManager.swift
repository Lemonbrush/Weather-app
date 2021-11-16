//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Александр on 20.06.2021.
//

import Foundation

struct UserDefaultsManager {
    struct UnitData {
        static func get() -> String? {
            return UserDefaults.standard.string(forKey: K.UserDefaults.unit)
        }

        static func set(with unit: String) {
            if unit == K.UserDefaults.imperial || unit == K.UserDefaults.metric {
                UserDefaults.standard.setValue(unit, forKey: K.UserDefaults.unit)
            }
        }
    }
    
    struct AppIcon {
        static func get() -> Int {
            return UserDefaults.standard.integer(forKey: "AppIconNumber")
        }

        static func set(with num: Int) {
            UserDefaults.standard.setValue(num, forKey: "AppIconNumber")
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
            let colorThemes = ColorThemeManager.getColorThemes()
            
            if colorThemes.count < num {
                return ColorThemeModel()
            }
            
            return colorThemes[num]
        }
        
        static func getCurrentColorTheme() -> ColorThemeModel {
            let currentColorThemeNumber = self.getCurrentColorThemeNumber()
            
            let colorThemes = ColorThemeManager.getColorThemes()
                
            if currentColorThemeNumber > colorThemes.count {
                return ColorThemeModel()
            }
            
            return colorThemes[currentColorThemeNumber]
        }
    }
}
