//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Александр on 20.06.2021.
//

import Foundation

enum Unit: String {
    case metric = "metric"
    case imperial = "imperial"
}

struct UserDefaultsManager {
    static func getUnitData() -> String? {
        return UserDefaults.standard.string(forKey: K.UserDefaults.unit)
    }
    
    static func setUnitData(with unit: Unit) {
        UserDefaults.standard.setValue(unit, forKey: unit.rawValue)
    }
}
