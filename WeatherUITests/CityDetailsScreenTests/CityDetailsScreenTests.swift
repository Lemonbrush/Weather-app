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
        app.tables.cells[K.AccessabilityIdentifier.mainMenuTableViewCell].firstMatch.tap()
        // act
        let mainDegreeLabel = app.staticTexts["CityDetailsMainDegreeLabel"].waitForExistence(timeout: 5)
        // assert
        XCTAssertTrue(mainDegreeLabel)
    }
}
