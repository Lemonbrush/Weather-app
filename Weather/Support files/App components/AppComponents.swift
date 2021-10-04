//
//  AppComponents.swift
//  Weather
//
//  Created by Alexander Rubtsov on 04.10.2021.
//

import Foundation

protocol ColorThemeProtocol {
    var colorTheme: ColorThemeModel? { get set }
}

class AppComponents: ColorThemeProtocol {
    var colorTheme: ColorThemeModel?
}
