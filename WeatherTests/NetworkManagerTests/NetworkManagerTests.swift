//
//  NetworkManagerTests.swift
//  WeatherTests
//
//  Created by Alexander Rubtsov on 14.09.2021.
//

import XCTest

class NetworkManagerTests: XCTestCase {

    var sut = NetworkManager()
    var networkManagerDelegate = NetworkManagerDelegateMock()

    override func setUp() {
        super.setUp()
        sut.delegate = networkManagerDelegate
    }

    func testFetchWeatherData() throws {
        // arrange
        let expectation = XCTestExpectation(description: "Fetch weather data")
        networkManagerDelegate.expection = expectation
        let queryCity = SavedCity(name: "Moscow", latitude: 0, longitude: 0)
        // act
        sut.fetchWeather(by: queryCity)
        // assert
        wait(for: [expectation], timeout: 10.0)
    }
}
