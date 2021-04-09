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
    var cityNames = ["Moscow", "London"] //Presaved queries
    var displayWeather: [WeatherModel] = [] //Fetched data for tableviews
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cityTable.contentInset.top = 10 //Space before the first cell
        
        weatherManager.delegate = self
        
        for cityName in cityNames {
            weatherManager.fetchWeather(cityName: cityName)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
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
        
        displayWeather.append(weather)
        
        DispatchQueue.main.sync {
            self.cityTable.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        fatalError("Failed with - \(error)")
    }
    
}

