//
//  WeatherManager.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel, at position: Int)
    func didFailWithError(error: Error)
}

struct NetworkManager {

    // MARK: - Public functions

    var delegate: NetworkManagerDelegate?

    // MARK: - Fetching weather data

    func fetchWeather(by city: SavedCity, at position: Int = 0) {
        let baseURL = K.Network.baseURL
        let lat = city.latitude
        let lon = city.longitude
        let appid = K.Network.apiKey
        let units = UserDefaultsManager.getUnitData() ?? "metric"
        let minutely = "minutely"

        let urlString = "\(baseURL)lat=\(lat)&lon=\(lon)&appid=\(appid)&units=\(units)&exclude=\(minutely)"
        performRequest(with: urlString, at: position)
    }

    // MARK: - Public functions

    private func performRequest(with urlString: String, at position: Int) {
        // Getting rid of any spaces in the URL string
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        if let url = URL(string: encodedURLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                let str = String(decoding: data!, as: UTF8.self)
                print("\n\n\n\(str)\n\n\n")
                // In case of error
                guard error == nil else {
                    delegate?.didFailWithError(error: error!) // let the delegate handle the error
                    return
                }

                // Handling result
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather, at: position)
                    }
                }
            }
            task.resume()
        }
    }

    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder() // Create decoder
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let result = WeatherModel(lat: decodedData.lat,
                                      lon: decodedData.lon,
                                      conditionId: decodedData.current.weather[0].id,
                                      cityName: "-",
                                      temperature: decodedData.current.temp,
                                      timezone: decodedData.timezone_offset,
                                      feelsLike: decodedData.current.feels_like,
                                      description: decodedData.current.weather[0].description,
                                      humidity: decodedData.current.humidity,
                                      uviIndex: decodedData.current.uvi,
                                      wind: decodedData.current.wind_speed,
                                      cloudiness: decodedData.current.clouds,
                                      pressure: decodedData.current.pressure,
                                      visibility: decodedData.current.visibility,
                                      sunrise: decodedData.current.sunrise,
                                      sunset: decodedData.current.sunset,
                                      daily: decodedData.daily,
                                      hourly: decodedData.hourly)
            return result
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
