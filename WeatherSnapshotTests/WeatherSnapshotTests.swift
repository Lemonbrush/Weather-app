//
//  WeatherSnapshotTests.swift
//  WeatherSnapshotTests
//
//  Created by Alexander Rubtsov on 17.09.2021.
//

import XCTest
import SnapshotTesting

//@testable import Weather

class TestAddCityScreen: XCTestCase {
    
    override class func setUp() {
        
    }

    func testAddCityScreenSnapshot() throws {
        let sut = AddCityViewController()
        assertSnapshot(matching: sut, as: .image(on: .iPhoneSe))
    }
}
