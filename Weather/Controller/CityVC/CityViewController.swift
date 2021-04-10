//
//  ViewController.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var cityTable: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var weatherManager = WeatherManager()
    var cityNames = ["Moscow", "London", "Kansas City", "Newcastle"] //Presaved queries
    var displayWeather: [WeatherModel] = [] //Fetched data for tableviews
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cityTable.contentInset.top = 10 //Space before the first cell
        
        weatherManager.delegate = self
        fetchWeatherData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //Helper functions
    func fetchWeatherData() {
        
        for cityName in cityNames {
            weatherManager.fetchWeather(cityName: cityName)
            let blankWeather = WeatherModel(conditionId: 0, cityName: cityName, temperature: 0)
            
            displayWeather.append(blankWeather)
        }
    }

}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        
        // Populate the cell with data
        cell.cityNameLabel.text = displayWeather[indexPath.row].cityName
        cell.degreeLabel.text = displayWeather[indexPath.row].weatherTemperatureString
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showCityDetailVC", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CityViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            
            //Find weather index and refresh its data
            for (i,cityName) in self.cityNames.enumerated() {
                
                if cityName == weather.cityName {
                    self.displayWeather[i] = weather
                }
            }
            
            self.cityTable.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        fatalError("Failed with - \(error)")
    }
    
}

