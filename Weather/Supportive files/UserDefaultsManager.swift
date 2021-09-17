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
}
