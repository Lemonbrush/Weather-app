//
//  MainMenuScreenPageObject.swift
//  WeatherUITests
//
//  Created by Alexander Rubtsov on 16.09.2021.
//

import XCTest

struct MainMenuScreenPageObject: Screen {
    
    let app: XCUIApplication
    
    private enum Identifiers {
        static let cityCell = "MainMenuTableViewCell"
        static let addCityButton = "SearchButton"
        static let settingsButton = "SettingsButton"
    }
    
    func tapAddCityButton() -> AddCityScreenPageObject {
        app.buttons[Identifiers.addCityButton].tap()
        return AddCityScreenPageObject(app: app)
    }
    
    func checkIfAnyCellsExist() -> Self {
        XCTAssertTrue(app.cells[Identifiers.cityCell].firstMatch.waitForExistence(timeout: 10))
        return self
    }
}
