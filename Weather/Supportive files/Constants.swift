//
//  Constants.swift
//  Weather
//
//  Created by Александр on 25.04.2021.
//

import Foundation

struct K {
    static let weatherAPIKey = "7a40aa4dd6b7cf1344d8f5679243fb0a"
    
    static let saveFileName = "savedCities.plist"
    
    static let cityCellIdentifier = "cityCell"
    static let weeklyCellIdentifier = "dailyCell"
    static let cityLoadingCellIdentifier = "cityLoadingCell"
    static let hourlyCellIdentifier = "hourlyCell"
    
    static let detailShowSegue = "detailShow"
    
    struct ImageName {
        static let deleteImage = "DeleteAction"
    }
    
    //Colors
    // ...
    
    struct CoreData {
        struct City {
            static let entityName = "City"
            static let name = "name"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let orderPosition = "orderPosition"
        }
    }
}
