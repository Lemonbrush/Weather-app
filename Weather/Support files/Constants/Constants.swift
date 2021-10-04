//
//  Constants.swift
//  Weather
//
//  Created by Александр on 25.04.2021.
//

import UIKit

struct K {
    struct CoreData {
        static let modelName = "CitiesModel"
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
        static let imperial = "imperial"
        static let metric = "metric"
        
        static let currentColorTheme = "currentColorTheme"
        static let colorThemePositionNumber = "colorThemePositionNumber"
    }

    struct Network {
        static let baseURL = "https://api.openweathermap.org/data/2.5/onecall?"
        static let apiKey = "3105f7f3ecb7b6032f375aaf58ed2253"
        static let lat = "lat="
        static let lon = "lon="
        static let appid = "appid="
        static let units = "units="
        static let exclude = "exclude="
        static let minutely = "minutely"
    }

    struct Colors {
        struct Gradient {
            static let day = [UIColor(red: 68 / 255, green: 166 / 255, blue: 252 / 255, alpha: 1).cgColor,
                              UIColor(red: 114 / 255, green: 225 / 255, blue: 253 / 255, alpha: 1).cgColor]
            static let night = [UIColor(red: 9 / 255, green: 7 / 255, blue: 40 / 255, alpha: 1).cgColor,
                                UIColor(red: 30 / 255, green: 94 / 255, blue: 156 / 255, alpha: 1).cgColor]
            static let blank = [UIColor.clear.cgColor]
            static let fog = [UIColor.clear.cgColor]
        }
        
        struct WeatherIcons {
            static let defaultColor = UIColor(red: 121 / 255, green: 199 / 255, blue: 248 / 255, alpha: 1)
            static let defaultSunColor = UIColor(red: 244 / 255, green: 189 / 255, blue: 59 / 255, alpha: 1)
        }
    }
}
