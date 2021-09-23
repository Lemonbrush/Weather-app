//
//  ViewController.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

protocol MainMenuDelegate: AnyObject {
    func fetchWeatherData()
}

protocol AddCityProtocol {
    func didAddNewCity()
    func didFailAddingNewCityWithError(error: Error?)
}

protocol AddCityDelegate: AddCityProtocol, DataStorageBasicProtocol, AnyObject {}

class MainMenuViewController: UIViewController, MainMenuDelegate {

    // MARK: - Private properties

    private let fadeTransitionAnimator = FadeTransitionAnimator()
    private var weatherManager = NetworkManager()
    private var tableView: UITableView?
    private var savedCities = [SavedCity]()
    private let mainManuView = MainMenuView()

    // MARK: - Public properties

    var dataStorage: DataStorageProtocol?
    var displayWeather: [WeatherModel?] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    // MARK: - Lifecycle

    override func loadView() {
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

    // MARK: - Functions

    // Navigation functions
    func showAddCityVC() {
        let destinationVC = AddCityViewController()
        destinationVC.delegate = self
        present(destinationVC, animated: true, completion: nil)
    }

    func showDetailViewVC() {
        let destinationVC = CityDetailViewController()
        let indexPath = self.tableView?.indexPathForSelectedRow!
        destinationVC.localWeatherData = displayWeather[indexPath!.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func showSettingsVC() {
        let destinationVC = SettingsTableViewController()
        destinationVC.mainMenuDelegate = self
        
        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true, completion: nil)
    }

    func fetchWeatherData() {
        guard let savedCities = dataStorage?.getSavedItems else { return }

        self.savedCities = savedCities
        displayWeather.removeAll()

        for _ in 0..<savedCities.count {
            displayWeather.append(nil)
        }

        for (i, city) in savedCities.enumerated() {
            weatherManager.fetchWeather(by: city, at: i)
        }
    }
}

extension MainMenuViewController: AddCityDelegate {
    var getSavedItems: [SavedCity]? {
        return dataStorage?.getSavedItems
    }

    func addNewItem(_ city: String, lat: Double, long: Double) {
        dataStorage?.addNewItem(city, lat: lat, long: long)
    }

    func deleteItem(at index: Int) {
        dataStorage?.deleteItem(at: index)
    }

    func rearrangeItems(at firstIndex: Int, to secondIndex: Int) {
        dataStorage?.rearrangeItems(at: firstIndex, to: secondIndex)
    }

    func didAddNewCity() {
        displayWeather.append(nil)
        tableView?.insertRows(at: [IndexPath(row: self.displayWeather.count - 1, section: 0)], with: .automatic)

        fetchWeatherData()
    }

    func didFailAddingNewCityWithError(error: Error?) {
        // TODO: handle new city adding failure
    }
}

extension MainMenuViewController: NetworkManagerDelegate {
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel, at position: Int) {

        DispatchQueue.main.async {

            self.displayWeather[position] = weather

            let indexPath = IndexPath(row: position, section: 0)

            // Put chosen city name from addCity autoCompletion into weather data model
            self.displayWeather[indexPath.row]?.cityName = self.savedCities[indexPath.row].name

            self.tableView?.reloadRows(at: [indexPath], with: .fade)
        }
    }

    func didFailWithError(error: Error) {
        print("Failed with - \(error)")
        // TODO: handle network disconection
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
