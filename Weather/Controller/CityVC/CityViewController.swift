//
//  ViewController.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var refreshControl = UIRefreshControl()
    
    var weatherManager = WeatherManager()
    var cityNames = ["Moscow", "London", "Kansas City", "Newcastle"] //Presaved queries
    var displayWeather: [WeatherModel] = [] //Fetched data for display in the tableview
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the date label
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        let result = dateFormatter.string(from: currentDate)
        currentDateLabel.text = result
        
        //Refresh control settings
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        cityTable.addSubview(refreshControl)
        
        //Space before the first cell
        cityTable.contentInset.top = 10
        
        weatherManager.delegate = self
        
        fetchWeatherData()
        
    }
    
    //Helper functions
    func fetchWeatherData() {
        
        displayWeather.removeAll()
        
        for cityName in cityNames {
            weatherManager.fetchWeather(cityName: cityName)
            let blankWeather = WeatherModel(conditionId: 0, cityName: cityName, temperature: 0)
            
            displayWeather.append(blankWeather)
        }
    }
    
    @objc func refreshWeatherData(_ sender: AnyObject) {
        fetchWeatherData()
        refreshControl.endRefreshing()
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

