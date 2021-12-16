//
//  ViewController.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

protocol MainMenuDelegate: ReloadColorThemeProtocol {
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
    private lazy var mainManuView = MainMenuView(colorThemeComponent: appComponents)
    private var activeErrorString: String?

    // MARK: - Public properties

    var appComponents: AppComponents
    var dataStorage: DataStorageProtocol?
    var displayWeather: [WeatherModel?] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return appComponents.colorTheme.mainMenu.isStatusBarDark ? .darkContent : .lightContent
    }

    // MARK: - Lifecycle
    
    init(appComponents: AppComponents) {
        self.appComponents = appComponents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        if displayWeather.isEmpty {
            showAddCityVC()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Functions

    func showAddCityVC() {
        let savedCityTitles = displayWeather.compactMap { $0?.cityName }
        let destinationVC = AddCityViewController(colorThemeComponent: appComponents, savedCityTitles: savedCityTitles)
        destinationVC.delegate = self
        present(destinationVC, animated: true, completion: nil)
    }

    func showDetailViewVC() {
        guard let displayWeatherIndex = self.tableView?.indexPathForSelectedRow?.row,
              let strongWeatherData = displayWeather[displayWeatherIndex] else {
                  let alert = AlertViewBuilder()
                      .build(title: "Oops", message: activeErrorString ?? "Something went wrong", preferredStyle: .alert)
                      .build(title: "Ok", style: .default, handler: nil)
                      .content
                  
                  DispatchQueue.main.async {
                      self.present(alert, animated: true, completion: nil)
                  }
            return
        }
        
        let destinationVC = CityDetailViewController(colorThemeComponent: appComponents)
        destinationVC.localWeatherData = strongWeatherData
        destinationVC.colorThemeComponent = appComponents
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func showSettingsVC() {
        let destinationVC = SettingsViewController(colorThemeComponent: appComponents)
        destinationVC.mainMenuDelegate = self

        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true, completion: nil)
    }

    func fetchWeatherData() {
        guard let savedCities = dataStorage?.getSavedItems else {
            return
        }

        self.savedCities = savedCities
        displayWeather.removeAll()

        for _ in 0..<savedCities.count {
            displayWeather.append(nil)
        }

        for (i, city) in savedCities.enumerated() {
            weatherManager.fetchWeather(by: city, at: i)
        }
    }
    
    func reloadColorTheme() {
        mainManuView.reloadViews()
        tableView?.reloadData()
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
        let errorMessage: String
        
        if let strongError = error {
            errorMessage = strongError.localizedDescription
        } else {
            errorMessage = "Something went wrong :<"
        }
        
        let alert = AlertViewBuilder()
            .build(title: "Oops", message: errorMessage, preferredStyle: .alert)
            .build(title: "Ok", style: .default, handler: nil)
            .content
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
        activeErrorString = error.localizedDescription
        let alert = AlertViewBuilder()
            .build(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
            .build(title: "Ok", style: .default, handler: nil)
            .content
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
