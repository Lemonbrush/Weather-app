//
//  NetworkManagerDelegateMock.swift
//  WeatherTests
//
//  Created by Alexander Rubtsov on 14.09.2021.
//

import XCTest

class NetworkManagerDelegateMock: NetworkManagerDelegate {
    
    var expection: XCTestExpectation?
    
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel, at position: Int) {
        expection?.fulfill()
    }
    
    func didFailWithError(error: Error) {
        XCTFail()
    }
}
