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
    
    let fadeTransitionAnimator = FadeTransitionAnimator()
    
    var refreshControl = UIRefreshControl()
    
    var weatherManager = WeatherManager()
    var cityNames = ["Moscow", "London", "Kansas City", "Newcastle", "Paris", "Tokyo"] //Presaved queries
    var displayWeather: [WeatherModel] = [] //Fetched data for display in the tableview
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
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
        //Getting rid of any delays between user touch and cell animation
        cityTable.delaysContentTouches = false
        
        weatherManager.delegate = self

        fetchWeatherData()
        
    }
    
    //Helper functions
    func fetchWeatherData() {
        
        displayWeather.removeAll()
        
        for cityName in cityNames {
            weatherManager.fetchWeather(cityName: cityName)
            
            //Populate table with blank cells
            let blankWeather = WeatherModel(conditionId: 0, cityName: cityName, temperature: 0, timezone: 0)
            
            displayWeather.append(blankWeather)
        }
    }
    
    //Pull-To-Refresh tableview
    @objc func refreshWeatherData(_ sender: AnyObject) {
        fetchWeatherData()
        refreshControl.endRefreshing()
    }
    
    //Transition to another viewcotroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityTableViewCell
        
        let weatherDataForCell = displayWeather[indexPath.row]
        
        // Populate the cell with data
        cell.cityNameLabel.text = weatherDataForCell.cityName
        cell.degreeLabel.text = weatherDataForCell.weatherTemperatureString
        
        //Setting up time label
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherDataForCell.timezone)
        dateFormatter.dateFormat = "hh:mm"
        cell.TimeLabel.text = dateFormatter.string(from: date)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailShow", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell {
            cell.isHighlighted = true
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell {
            cell.isHighlighted = false
        }
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

extension CityViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return fadeTransitionAnimator
    }
}

