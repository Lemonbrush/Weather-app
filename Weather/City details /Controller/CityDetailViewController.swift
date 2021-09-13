//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Александр on 06.04.2021.
//

import UIKit

class CityDetailViewController: UIViewController {
    
    //MARK: - Public properties
    
    var localWeatherData: WeatherModel?
    
    //MARK: - Private properties
    
    private let backButtonNavBarItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(backButtonPressed))
        button.tintColor = .black
        return button
    }()
    
    private let navigationBarBlurBackground: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never ///Header view begins under the navigation bar and getting rid of the gap at the bottom
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Screen's first part
    
    private var topTranslucentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var degreeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WelcomeImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var tempLebel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 90, weight: .medium)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    //MARK: - Screen's second part
    
    private var bottomWhiteBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var hourlyCollectionView: HourlyForecastView = {
        let hourlyCollectionView = HourlyForecastView()
        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return hourlyCollectionView
    }()
    
    private var weeklyForecastTableView: WeeklyForecastTableView = {
        let weeklyTableView = WeeklyForecastTableView()
        weeklyTableView.translatesAutoresizingMaskIntoConstraints = false
        return weeklyTableView
    }()
    
    private var weatherQualityInfoView: WeatherQualityInfoView = {
        let qualityView = WeatherQualityInfoView()
        qualityView.translatesAutoresizingMaskIntoConstraints = false
        return qualityView
    }()
    
    //Constraints
    private let hourlyForecastHeightConstant: CGFloat = 100
    private var hourlyTopConstant: CGFloat = 8
    private let springDefaultConstant: CGFloat = 50
    
    private var hourlyHeightConstraint = NSLayoutConstraint()
    private var weeklyTableViewHightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var springConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var extraContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var weeklyTableViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Background views
    private var weeklyTableBackground: UIView = UIView()
    
    private let gradientBackground = CAGradientLayer()
    private var weatherManager = NetworkManager()
    private var updateTimer: Timer?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(backButtonPressed))
        button.tintColor = .black
        self.navigationItem.leftBarButtonItem = button
        
        weatherManager.delegate = self
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(topTranslucentBackground)
        
        degreeStackView.addArrangedSubview(conditionImage)
        degreeStackView.addArrangedSubview(tempLebel)
        degreeStackView.addArrangedSubview(descriptionLabel)
        degreeStackView.addArrangedSubview(feelsLikeLabel)
        topTranslucentBackground.addSubview(degreeStackView)
        
        scrollContentView.addSubview(bottomWhiteBackground)
        
        hourlyCollectionView.dataSource = localWeatherData
        bottomWhiteBackground.addSubview(hourlyCollectionView)
        extraContentStackView.addArrangedSubview(weeklyForecastTableView)
        extraContentStackView.addArrangedSubview(weatherQualityInfoView)
        bottomWhiteBackground.addSubview(extraContentStackView)
        
        setupBlurableNavBar()
        view.addSubview(navigationBarBlurBackground)
        
        setupGradientBackground()
        
        //Setting up display data
        if let safeWeatherData = localWeatherData {
            title = safeWeatherData.cityName
            setLabelsAndImages(with: safeWeatherData)
        }
        
        //Setting up autoFetching data timer
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fetchWeatherData), userInfo: nil, repeats: true)
        updateTimer?.fire()
        
        setUpConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        //Set tableview height according to its contents
        weeklyTableViewHightConstraint.constant = weeklyForecastTableView.tableView.contentSize.height
        
        //Calculate gradient size
        gradientBackground.frame = view.bounds
        scrollView.contentSize = scrollContentView.bounds.size
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    //MARK: - Private Functions
    
    private func setUpConstraints() {
        //Nav bar
        navigationBarBlurBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBarBlurBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBarBlurBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let navBarSize = navigationController?.navigationBar.bounds ?? CGRect.zero
        let statusBarSize = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        let overallNavBarHeight = navBarSize.height + statusBarSize.height
        navigationBarBlurBackground.heightAnchor.constraint(equalToConstant: overallNavBarHeight).isActive = true
        
        //ScrollView
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //ScrollContentView
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        //Top translucent view
        topTranslucentBackground.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        topTranslucentBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        topTranslucentBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        topTranslucentBackground.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - hourlyForecastHeightConstant - hourlyTopConstant - 40).isActive = true
        
        //Degree stackView
        degreeStackView.centerYAnchor.constraint(equalTo: topTranslucentBackground.centerYAnchor).isActive = true
        degreeStackView.centerXAnchor.constraint(equalTo: topTranslucentBackground.centerXAnchor).isActive = true
        
        //Condition image
        conditionImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        conditionImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //BottombackgroundView
        bottomWhiteBackground.topAnchor.constraint(equalTo: topTranslucentBackground.bottomAnchor).isActive = true
        bottomWhiteBackground.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
        bottomWhiteBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        bottomWhiteBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        
        //Hourly collection view
        hourlyCollectionView.leadingAnchor.constraint(equalTo: bottomWhiteBackground.leadingAnchor).isActive = true
        hourlyCollectionView.trailingAnchor.constraint(equalTo: bottomWhiteBackground.trailingAnchor).isActive = true
        
        hourlyHeightConstraint = NSLayoutConstraint(item: hourlyCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: hourlyForecastHeightConstant)
        hourlyCollectionView.addConstraint(hourlyHeightConstraint)
        hourlyCollectionView.heightAnchor.constraint(equalToConstant: hourlyForecastHeightConstant).isActive = true
        hourlyCollectionView.topAnchor.constraint(equalTo: bottomWhiteBackground.topAnchor, constant: hourlyTopConstant).isActive = true
        
        //Additional content Stack
        springConstraint = NSLayoutConstraint(item: extraContentStackView, attribute: .top, relatedBy: .equal, toItem: hourlyCollectionView, attribute: .bottom, multiplier: 1, constant: 65)
        springConstraint.isActive = true
        extraContentStackView.leadingAnchor.constraint(equalTo: bottomWhiteBackground.leadingAnchor, constant: 20).isActive = true
        extraContentStackView.trailingAnchor.constraint(equalTo: bottomWhiteBackground.trailingAnchor, constant: -20).isActive = true
        extraContentStackView.bottomAnchor.constraint(equalTo: bottomWhiteBackground.bottomAnchor, constant: -springDefaultConstant).isActive = true
        
        //Weekly tableView height
        weeklyTableViewHightConstraint = NSLayoutConstraint(item: weeklyForecastTableView.tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        weeklyTableViewHightConstraint.isActive = true
    }
    
    private func setupBlurableNavBar() {
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationBarBlurBackground.alpha = 0
    }
    
    private func setupGradientBackground() {
        gradientBackground.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientBackground.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientBackground.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientBackground.colors = DesignManager.getStandartGradientColor(withStyle: .day)
        self.view.layer.insertSublayer(gradientBackground, at: 0)
    }
    
    private func setLabelsAndImages(with newData: WeatherModel) {
        let conditionImageName = WeatherModel.getConditionNameBy(conditionId: newData.conditionId)
        conditionImage.image = UIImage(systemName: conditionImageName)?.withRenderingMode(.alwaysTemplate)
        conditionImage.tintColor = .white
        
        tempLebel.text = newData.temperatureString
        
        let feelsLikeDescriptionString = newData.description.prefix(1).capitalized + newData.description.dropFirst() ///Capitalize the first letter
        descriptionLabel.text = feelsLikeDescriptionString
        
        feelsLikeLabel.text = newData.feelsLikeString
        
        weeklyForecastTableView.reloadData(newData)
        weatherQualityInfoView.setupValues(weatherData: newData)
    }
    
    private func updateDisplayData(with newData: WeatherModel) {
        //weeklyForecastTableView.tableView.reloadData()
        setLabelsAndImages(with: newData)
        weeklyForecastTableView.reloadData(newData)
        hourlyCollectionView.collectionView.reloadData()
        weatherQualityInfoView.setupValues(weatherData: newData)
        
        localWeatherData = newData
    }
    
    //MARK: - Actions
    
    @objc func fetchWeatherData() {
        guard let safeWeatherData = localWeatherData else { return }
        weatherManager.fetchWeather(by: safeWeatherData.cityRequest)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ScrollView

extension CityDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Check if CollectionView is currently scrolling and break if so
        if hourlyCollectionView.collectionView.isDragging || hourlyCollectionView.collectionView.isDecelerating { return }
            
        //Handle navigation bar appearance according to the scroll view offset
        let targetHeight = (topTranslucentBackground.bounds.height - degreeStackView.bounds.height)/2 - navigationBarBlurBackground.bounds.height
        //Calculate how much has been scrolled relative to the target
        let offset = scrollView.contentOffset.y/targetHeight
        navigationBarBlurBackground.alpha = offset
        
        // Spring constant will change its value by scrolling to half of its size
        let oldConstant = hourlyTopConstant
        let newConstant: CGFloat = scrollView.contentOffset.y < hourlyTopConstant/2 ? springDefaultConstant : 25
        
        if oldConstant != newConstant {
            UIView.animate(withDuration: 0.1) {
                self.springConstraint.constant = newConstant
                self.view.layoutIfNeeded()
            }
        }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
}

// MARK: - Data fetching

extension CityDetailViewController: NetworkManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel, at position: Int) {
        DispatchQueue.main.async {
            self.updateDisplayData(with: weather)
        }
    }
    
    func didFailWithError(error: Error) {
        //Handle the error
    }
}
