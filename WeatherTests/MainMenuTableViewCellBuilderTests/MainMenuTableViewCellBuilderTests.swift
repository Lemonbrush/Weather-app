//
//  MainMenuTableViewCellBuilderTests.swift
//  WeatherTests
//
//  Created by Alexander Rubtsov on 15.09.2021.
//

import XCTest
import UIKit

class MainMenuTableViewCellBuilderTests: XCTestCase {

    let builder = MainMenuCellBuilder()

    func testMainMenuTableViewCellBuilderMakeCellWithCityLabel() throws {
        // arrange
        let cityName = "MoscowTest"
        // act
        let result = builder
            .erase()
            .build(cityLabelByString: cityName)
            .content
        // assert
        XCTAssertEqual(result.cityNameLabel.text, cityName)
    }

    func testMainMenuTableViewCellBuilderMakeCellDegreeLabel() throws {
        // arrange
        let cityDegree = "10"
        // act
        let result = builder
            .erase()
            .build(degreeLabelByString: cityDegree)
            .content
        // assert
        XCTAssertEqual(result.degreeLabel.text, cityDegree)
    }

    func testMainMenuTableViewCellBuilderMakeCellCityTimeZone() throws {
        // arrange
        let cityTimeZone = TimeZone.current
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = cityTimeZone
        dateFormatter.dateFormat = "hh:mm"
        // act
        let result = builder
            .erase()
            .build(timeLabelByTimeZone: cityTimeZone)
            .content
        // assert
        XCTAssertEqual(result.timeLabel.text, dateFormatter.string(from: date))
    }

    func testMainMenuTableViewCellBuilderMakeCell() throws {
        // arrange
        let conditionId = 500
        let cellImageName = WeatherModel.getConditionNameBy(conditionId: conditionId)
        let expectedImage = UIImage(systemName: cellImageName)?.withTintColor(.black)
        // act
        let result = builder
            .erase()
            .build(imageByConditionId: conditionId)
            .content
        // assert
        XCTAssertEqual(result.conditionImage.image?.ciImage, expectedImage?.ciImage)
    }
}
