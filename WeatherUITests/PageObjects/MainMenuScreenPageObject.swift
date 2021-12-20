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
        static let cityCell = K.AccessabilityIdentifier.mainMenuTableViewCell
        static let addCityButton = K.AccessabilityIdentifier.searchButton
        static let settingsButton = K.AccessabilityIdentifier.settingsButton
    }

    func tapAddCityButton() -> AddCityScreenPageObject {
        app.buttons[Identifiers.addCityButton].tap()
        return AddCityScreenPageObject(app: app)
    }
    
    func getAddCityScreen() -> AddCityScreenPageObject {
        return AddCityScreenPageObject(app: app)
    }

    func checkIfAnyCellsExist() -> Self {
        XCTAssertTrue(app.cells[Identifiers.cityCell].firstMatch.waitForExistence(timeout: 10))
        return self
    }
}
