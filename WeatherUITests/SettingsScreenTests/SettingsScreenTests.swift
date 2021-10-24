//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Alexander Rubtsov on 16.09.2021.
//

import XCTest

class SettingsScreenTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSettingsScreenOpening() throws {
        // arrange
        app.buttons["SettingsButton"].tap()
        // act
        let idSettingsScreenOpened = app.tables["SettingsTableView"].exists
        // assert
        XCTAssertTrue(idSettingsScreenOpened)
    }
}
