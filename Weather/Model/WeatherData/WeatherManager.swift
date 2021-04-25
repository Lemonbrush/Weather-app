//
//  WeatherManager.swift
//  Weather
//
//  Created by Александр on 08.04.2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel])
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "http://api.openweathermap.org/data/2.5/group?"
    var city = ""
    let appid = K.weatherAPIKey
    var units = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    //MARK: - Fetching weather data
    func fetchWeather(cityIDs: [String]) {
        guard cityIDs.count > 0 else {
            return
        }
        
        let cityIDsStr = cityIDs.joined(separator: ",")
        
        let urlString = "\(weatherURL)id=\(cityIDsStr)&appid=\(appid)&units=\(units)"
        performRequest(with: urlString)
    }
    
    //MARK: - Networking
    func performRequest(with urlString: String) {
        
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
                        delegate?.didUpdateWeather(self, weather: weather) //Let the delegate refresh data tables
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> [WeatherModel]? {
        let decoder = JSONDecoder() //Create decoder
        
        do {
            let decodedData = try decoder.decode(WeatherDataBundle.self, from: weatherData) //Decode data to conform WeatherData properties
            
            var weatherBundle = [WeatherModel]()
            
            for weatherData in decodedData.list {
                weatherBundle.append(WeatherModel(conditionId: weatherData.weather[0].id,
                                                  cityName: weatherData.name,
                                                  temperature: weatherData.main.temp,
                                                  timezone: weatherData.sys.timezone))
            }
            
            return weatherBundle
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}

