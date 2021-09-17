//
//  AddCityScreenTests.swift
//  WeatherTests
//
//  Created by Alexander Rubtsov on 16.09.2021.
//

import XCTest

class AddCityScreenTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testExample() throws {
        _ = MainMenuScreenPageObject(app: app)
            .tapAddCityButton()
            .typeCityName("Moscow")
            .chooseCity()
            .checkIfAnyCellsExist()
    }
}
