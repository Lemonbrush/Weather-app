//
//  CountryModel.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import Foundation

struct CityModel: Codable {
    let id: Int
    let state: String
    let countryID: String
    let cityName: String
    let countryName: String
}
