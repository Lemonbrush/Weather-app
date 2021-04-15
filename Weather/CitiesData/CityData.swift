//
//  CityData.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

/*

 [
     {
         "id": 833,
         "name": "Ḩeşār-e Sefīd",
         "state": "",
         "country": "IR",
         "coord": {
             "lon": 47.159401,
             "lat": 34.330502
         }
     },
     {
         "id": 2960,
         "name": "‘Ayn Ḩalāqīm",
         "state": "",
         "country": "SY",
         "coord": {
             "lon": 36.321911,
             "lat": 34.940079
         }
     },
     {
         "id": 3245,
         "name": "Taglag",
         "state": "",
         "country": "IR",
         "coord": {
             "lon": 44.98333,
             "lat": 38.450001
         }
     },
     {
        ...
*/

import Foundation

//Data struct for JSON encoding
struct CityData: Codable {
    let id: Int
    let state: String
    let country: String
    let name: String
}

