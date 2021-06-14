//
//  WeatherManager.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, at position: Int)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?"
    var city = ""
    let appid = K.weatherAPIKey
    var units = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    //MARK: - Fetching weather data
    func fetchWeather(by city: SavedCity, at position: Int) {
        
        let urlString = "\(weatherURL)lat=\(city.latitude)&lon=\(city.longitude)&appid=\(appid)&units=\(units)&exclude=minutely"
        performRequest(with: urlString, at: position)
    }
    
    //MARK: - Networking
    func performRequest(with urlString: String, at position: Int) {
        
        //Getting rid of any spaces in the URL string
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        if let url = URL(string: encodedURLString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                //In case of error
                guard (error == nil) else{
                    delegate?.didFailWithError(error: error!) //let the delegate handle the error
                    return
                }
                
                //Handling result
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather, at: position) //Let the delegate refresh data tables
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder() //Create decoder
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //Decode data to conform WeatherData properties
            
            let result = WeatherModel(conditionId: decodedData.current.weather[0].id,
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
                                      daily: decodedData.daily,
                                      hourly: decodedData.hourly)
            
            return result
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}

