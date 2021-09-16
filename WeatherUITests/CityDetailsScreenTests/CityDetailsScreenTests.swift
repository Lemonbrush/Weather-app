//
//  CityDetailsScreenTests.swift
//  WeatherUITests
//
//  Created by Alexander Rubtsov on 16.09.2021.
//

import XCTest

class CityDetailsScreenTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testCityDetailScreenOpening() throws {
        // arrange
        app.tables.cells["MainMenuTableViewCell"].firstMatch.tap()
        // act
        let mainDegreeLabel = app.staticTexts["CityDetailsMainDegreeLabel"].exists
        // assert
        XCTAssertTrue(mainDegreeLabel)
    }
}
