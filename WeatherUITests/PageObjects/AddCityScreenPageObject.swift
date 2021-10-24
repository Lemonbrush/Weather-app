//
//  CityDetailScreen.swift
//  WeatherUITests
//
//  Created by Alexander Rubtsov on 16.09.2021.
//

import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct AddCityScreenPageObject: Screen {

    let app: XCUIApplication

    private enum Identifiers {
        static let textField = "AddCityTextField"
        static let cancelButton = "AddCityCancelButton"
        static let cityCell = "AddCityCell"
    }

    func typeCityName(_ cityName: String) -> Self {
        let textfield = app.textFields[Identifiers.textField]
        textfield.tap()
        textfield.typeText(cityName)
        return self
    }

    func chooseCity() -> MainMenuScreenPageObject {
        app.cells[Identifiers.cityCell].firstMatch.tap()
        return MainMenuScreenPageObject(app: app)
    }

    func tapCancelButton() -> MainMenuScreenPageObject {
        app.buttons[Identifiers.cancelButton].tap()
        return MainMenuScreenPageObject(app: app)
    }
}
