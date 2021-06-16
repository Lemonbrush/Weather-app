//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Александр on 06.04.2021.
//

import UIKit

/*
enum hourlyCellType {
    case weatherType;
    case sunType;
}
*/

class CityDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Constraints
    @IBOutlet weak var tableHight: NSLayoutConstraint!
    @IBOutlet weak var whiteBackgroundView: NSLayoutConstraint!
    @IBOutlet weak var hourlyForecastHeight: NSLayoutConstraint!
    @IBOutlet weak var hourlySpringConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var transparentTopBAckground: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Background views
    @IBOutlet weak var weeklyTableBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    
    @IBOutlet weak var conditionImage: UIImageView!
    
    //Labels
    @IBOutlet weak var tempLebel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    var weatherModel: WeatherModel! //The data sourse
    
    //var hourlyData: [hourlyCellType]!
    
    var weatherManager = WeatherManager()
    
    let gradientBackground = CAGradientLayer()
    
    let navigationBarBlurBackground = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var updateTimer: Timer!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        
        //Setting up clear background for navigation bar
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        
        //Setting up background navigation bar blur view
        let navBarSize = navigationController?.navigationBar.bounds ?? CGRect.zero
        let statusBarSize = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        let overallNavBarHeight = navBarSize.height + statusBarSize.height
        
        navigationBarBlurBackground.bounds = CGRect(x: -statusBarSize.width/2,
                                                    y: -overallNavBarHeight/2,
                                   width: navBarSize.width,
                                   height: overallNavBarHeight)
        
        navigationBarBlurBackground.alpha = 0
        
        view.addSubview(navigationBarBlurBackground)
        
        //ScrollView
        scrollView.delegate = self
        //Header view begins under the navigation bar and getting rid of the gap at the bottom
        scrollView.contentInsetAdjustmentBehavior = .never
        
        //Setting up gradient background
        gradientBackground.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientBackground.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientBackground.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientBackground.colors = DesignManager.getStandartGradientColor(withStyle: .day)
        self.view.layer.insertSublayer(gradientBackground, at: 0)
        
        //Set up background shapes
        DesignManager.setBackgroundStandartShape(layer: weeklyTableBackground.layer)
        DesignManager.setBackgroundStandartShape(layer: humidityBackground.layer)
        
        //Set up background shadows
        DesignManager.setBackgroundStandartShadow(layer: weeklyTableBackground.layer)
        DesignManager.setBackgroundStandartShadow(layer: humidityBackground.layer)
        
        //Setting up display data
        title = weatherModel.cityName
        updateDisplayData()
        
        //Setting up autoFetching data timer
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fetchWeatherData), userInfo: nil, repeats: true)
        updateTimer.fire()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        //Set tableview height according to its contents
        tableHight.constant = tableView.contentSize.height
        
        //Calculate gradient size
        gradientBackground.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Adjast view so that hourly forecast only could be seen at the bottom
        whiteBackgroundView.constant = view.frame.height - (hourlyForecastHeight.constant + hourlySpringConstraint.constant)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateTimer.invalidate()
    }
    
    //MARK: - Helper functions
    
    @objc func fetchWeatherData() {
        weatherManager.fetchWeather(by: weatherModel.cityRequest)
    }
    
    func updateDisplayData() {
        
        let conditionImageName = WeatherModel.getcConditionNameBy(conditionId: weatherModel.conditionId)
        conditionImage.image = UIImage(systemName: conditionImageName)
        
        tempLebel.text = weatherModel.temperatureString
        
        //Capitalize the first letter
        let feelsLikeDescriptionString = weatherModel.description.prefix(1).capitalized + weatherModel.description.dropFirst()
        descriptionLabel.text = feelsLikeDescriptionString
        
        feelsLikeLabel.text = weatherModel.feelsLikeString
        
        humidityLabel.text = weatherModel.humidityString
        uvIndexLabel.text = String(weatherModel.uviIndex)
        windLabel.text = weatherModel.windString
        cloudinessLabel.text = weatherModel.cloudinessString
        pressureLabel.text = weatherModel.pressureString
        visibilityLabel.text = weatherModel.visibilityString
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ScrollView

extension CityDetailViewController: UIScrollViewDelegate {
    
    //Calls on scrolling scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Check if CollectionView is currently scrolling and break if so
        if collectionView.isDragging || collectionView.isDecelerating { return }
            
        //Handle navigation bar appearance according to the scroll view offset
        let targetHeight = (transparentTopBAckground.bounds.height - topStackView.bounds.height)/2 - navigationBarBlurBackground.bounds.height
        
        //Calculate how much has been scrolled relative to the target
        let offset = scrollView.contentOffset.y/targetHeight
        
        navigationBarBlurBackground.alpha = offset
        
        // Hourly forecast view handling
        let oldConstant = self.hourlySpringConstraint.constant
        //The constraint will change its value by scrolling to half of its size
        let newConstant: CGFloat = scrollView.contentOffset.y < hourlySpringConstraint.constant/2 ? 50 : 25
        
        //Adjast hourlyForecast view by scrolling
        if oldConstant != newConstant {
            UIView.animate(withDuration: 0.1) {
                self.hourlySpringConstraint.constant = newConstant
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

// MARK: - TableView

extension CityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TODO: here should be weekly forecast
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.dailyCellIdentifier) as! DailyTableViewCell
        
        let targetWeather = weatherModel.daily[indexPath.row]
        
        //Setting up date
        let date = Date(timeIntervalSince1970: TimeInterval(targetWeather.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherModel.timezone)
        dateFormatter.dateFormat = "d EE"
        
        cell.monthLabel.text = dateFormatter.string(from: date)
        
        cell.temperatureLabel.text = String(format: "%.0f°", targetWeather.temp.max)
        cell.minTemperatureLabel.text = String(format: "%.0f°", targetWeather.temp.min)
        
        let cellImageName = WeatherModel.getcConditionNameBy(conditionId: targetWeather.weather[0].id)
        cell.conditionImage.image = UIImage(systemName: cellImageName)
        
        return cell
    }
    
}

// MARK: - CollectionView

extension CityDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel.hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.hourlyCellIdentifier, for: indexPath) as! HourlyCollectionViewCell
        
        let targetHourlyForecast = weatherModel.hourly[indexPath.row]
        
        cell.degreeLabel.text = String(format: "%.0f°", targetHourlyForecast.temp)
        
        //Setting up date
        let date = Date(timeIntervalSince1970: TimeInterval(targetHourlyForecast.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherModel.timezone)
        dateFormatter.dateFormat = "h a"
        
        cell.timeLabel.text = dateFormatter.string(from: date)
        
        let cellImageName = WeatherModel.getcConditionNameBy(conditionId: targetHourlyForecast.weather[0].id)
        cell.image.image = UIImage(systemName: cellImageName)
        
        return cell
    }
    
    //Space insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - Data fetching

extension CityDetailViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel, at position: Int) {
        
        DispatchQueue.main.async {
            self.weatherModel = weather
            self.updateDisplayData()
        }
    }
    
    func didFailWithError(error: Error) {
        //Handle the error
    }
}
