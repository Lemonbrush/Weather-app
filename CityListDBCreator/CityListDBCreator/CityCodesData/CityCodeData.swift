//
//  CityCodeData.swift
//  CityListDBCreator
//
//  Created by Александр on 17.04.2021.
//

/*

 [
    {
       "Code": "AF",
       "Name": "Afghanistan"
    },
    {
       "Code": "AX",
       "Name": "Åland Islands"
    },
    {
       "Code": "AL",
       "Name": "Albania"
    },
 
 ...
 
*/

import Foundation

struct CityCodeData: Codable {
    let Code: String
    let Name: String
}
