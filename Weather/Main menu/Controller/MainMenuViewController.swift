//
//  ViewController.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let fadeTransitionAnimator = FadeTransitionAnimator()
    private var weatherManager = WeatherManager()
    private var tableView: UITableView?
    private var savedCities = [SavedCity]()
    private let mainManuView = MainMenuView()
    
    //MARK: - Public properties
    
    var displayWeather: [WeatherModel?] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = mainManuView
        mainManuView.viewController = self
        tableView = mainManuView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        weatherManager.delegate = self
        
        fetchWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Functions
    
    func showAddCityVC() {
        let destinationVC = AddCityViewController()
        destinationVC.delegate = self
        present(destinationVC, animated: true, completion: nil)
    }
    
    func showDetailViewVC() {
        let destinationVC = CityDetailViewController()
        let indexPath = self.tableView?.indexPathForSelectedRow!
        destinationVC.localWeatherData = displayWeather[indexPath!.row]
        present(destinationVC, animated: true, completion: nil)
    }
    
    func showSettingsVC() {
        present(SettingsTableViewController(), animated: true, completion: nil)
    }

    func fetchWeatherData() {
        guard let savedCities = CityDataFileManager.getSavedCities() else { return }
        
        self.savedCities = savedCities
        displayWeather.removeAll()
        
        for _ in 0..<savedCities.count {
            displayWeather.append(nil)
        }
        
        for (i,city) in savedCities.enumerated() {
            weatherManager.fetchWeather(by: city, at: i)
        }
    }
}

extension MainMenuViewController: AddCityDelegate {
    
    func didAddNewCity() {
        displayWeather.append(nil)
        tableView?.insertRows(at: [IndexPath(row: self.displayWeather.count-1, section: 0)], with: .automatic)
        
        fetchWeatherData()
    }
    
    func didFailAddingNewCityWithError(error: Error?) {
        //handle errors here
    }
}

extension MainMenuViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, at position: Int) {
        
        DispatchQueue.main.async {
            
            self.displayWeather[position] = weather
            
            let indexPath = IndexPath(row: position, section: 0)
            
            //Put chosen city name from addCity autoCompletion into weather data model
            self.displayWeather[indexPath.row]?.cityName = self.savedCities[indexPath.row].name
            
            self.tableView?.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed with - \(error)")
        //TODO: handle network disconection
    }
}

// MARK: - Transition animation

extension MainMenuViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return fadeTransitionAnimator
    }
}
