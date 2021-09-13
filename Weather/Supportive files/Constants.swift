//
//  Constants.swift
//  Weather
//
//  Created by Александр on 25.04.2021.
//

import Foundation

struct K {
    static let weatherAPIKey = "7a40aa4dd6b7cf1344d8f5679243fb0a"
    
    struct CoreData {
        struct City {
            static let entityName = "City"
            static let name = "name"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let orderPosition = "orderPosition"
        }
    }
    
    struct CellIdentifier {
        static let cityCell = "cityCell"
        static let cityLoadingCell = "cityLoadingCell"
        static let dailyForecastCell = "dailyForecastCell"
        static let hourlyForecastCell = "hourlyForecastCell"
    }
    
    struct ImageName {
        static let deleteImage = "DeleteAction"
        static let defaultImage = "WelcomeImage"
    }
    
    struct UserDefaults {
        static let unit = "Unit"
    }
    
    //TODO: Colors
    // ...
}
