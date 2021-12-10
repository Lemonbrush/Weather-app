//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Александр on 06.04.2021.
//

import UIKit

class CityDetailViewController: UIViewController {

    // MARK: - Public properties

    var localWeatherData: WeatherModel?
    var colorThemeComponent: ColorThemeProtocol
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .darkContent : .lightContent
    }

    // MARK: - Private properties

    private lazy var backButtonNavBarItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonPressed))
        button.tintColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .black : .white
        
        return button
    }()

    private lazy var navigationBarBlurBackground: UIVisualEffectView = {
        let isNavBarDark = colorThemeComponent.colorTheme.cityDetails.isNavBarDark
        let view = UIVisualEffectView(effect: UIBlurEffect(style: isNavBarDark ? .dark : .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Screen's first part

    private var topTranslucentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var degreeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Grid.pt12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: K.ImageName.defaultImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var tempLebel: DegreeLabel = {
        let label = DegreeLabel()
        label.accessibilityIdentifier = "CityDetailsMainDegreeLabel"
        label.font = UIFont.systemFont(ofSize: Grid.pt92, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Grid.pt32, weight: .medium)
        return label
    }()

    private var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Grid.pt20, weight: .medium)
        return label
    }()

    // MARK: - Screen's second part

    private lazy var secondScreenPartBackground: UIView = {
        let view = UIView()
        let contentBackground = colorThemeComponent.colorTheme.cityDetails.contentBackground
        view.backgroundColor = contentBackground.isClearBackground ? .clear : contentBackground.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var hourlyCollectionView: HourlyForecastView = {
        let hourlyCollectionView = HourlyForecastView(colorThemeComponent: colorThemeComponent)
        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return hourlyCollectionView
    }()

    private lazy var weeklyForecastTableView: WeeklyForecastTableView = {
        let weeklyTableView = WeeklyForecastTableView(colorThemeComponent: colorThemeComponent)
        weeklyTableView.translatesAutoresizingMaskIntoConstraints = false
        return weeklyTableView
    }()

    private lazy var weatherQualityInfoView: WeatherQualityInfoView = {
        let qualityView = WeatherQualityInfoView(colorThemeComponent: colorThemeComponent)
        qualityView.translatesAutoresizingMaskIntoConstraints = false
        return qualityView
    }()

    // Constraints
    private let hourlyForecastHeightConstant: CGFloat = Grid.pt100
    private var hourlyTopConstant: CGFloat = Grid.pt8
    private let springDefaultConstant: CGFloat = Grid.pt52

    private var hourlyHeightConstraint = NSLayoutConstraint()
    private var weeklyTableViewHightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var springConstraint: NSLayoutConstraint = NSLayoutConstraint()

    private var extraContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Grid.pt24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var weeklyTableViewBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Background views
    private var weeklyTableBackground: UIView = UIView()

    private let gradientBackground = CAGradientLayer()
    private var weatherManager = NetworkManager()
    private var updateTimer: Timer?

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButtonNavBarItem.action = #selector(backButtonPressed)
        backButtonNavBarItem.target = self
        self.navigationItem.leftBarButtonItem = backButtonNavBarItem

        weatherManager.delegate = self

        scrollView.delegate = self
        view.addSubview(scrollView)

        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(topTranslucentBackground)
        
        let backgroundColors = colorThemeComponent.colorTheme.cityDetails.screenBackground
        let currentThemeLabelColor = colorThemeComponent.colorTheme.getColorByConditionId(localWeatherData?.conditionId ?? 0).labelsColor
        let labelColor = backgroundColors.ignoreColorInheritance ? backgroundColors.labelsColor : currentThemeLabelColor
        tempLebel.textColor = labelColor
        descriptionLabel.textColor = labelColor
        feelsLikeLabel.textColor = labelColor
        degreeStackView.addArrangedSubview(conditionImage)
        degreeStackView.addArrangedSubview(tempLebel)
        degreeStackView.addArrangedSubview(descriptionLabel)
        degreeStackView.addArrangedSubview(feelsLikeLabel)
        topTranslucentBackground.addSubview(degreeStackView)

        scrollContentView.addSubview(secondScreenPartBackground)

        hourlyCollectionView.dataSource = localWeatherData
        secondScreenPartBackground.addSubview(hourlyCollectionView)
        
        extraContentStackView.addArrangedSubview(weeklyForecastTableView)
        extraContentStackView.addArrangedSubview(weatherQualityInfoView)
        secondScreenPartBackground.addSubview(extraContentStackView)

        setupBlurableNavBar()
        view.addSubview(navigationBarBlurBackground)

        setupGradientBackground()

        if let safeWeatherData = localWeatherData {
            let navBarTitleColor: UIColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .black : .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTitleColor]
            title = safeWeatherData.cityName
            setLabelsAndImages(with: safeWeatherData)
        }

        updateTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                           target: self,
                                           selector: #selector(fetchWeatherData),
                                           userInfo: nil,
                                           repeats: true)
        updateTimer?.fire()

        setUpConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        weeklyTableViewHightConstraint.constant = weeklyForecastTableView.tableView.contentSize.height // Set tableview height according to its contents
        gradientBackground.frame = view.bounds // Calculate gradient size
        scrollView.contentSize = scrollContentView.bounds.size
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }

    // MARK: - Private Functions

    private func setUpConstraints() {
        setUpNavBar()
        setupBlurableNavBar()
        setUpScrollView()
        setUpScrollContentView()
        setUpTopTranslucentView()
        setUpDegreeStackView()
        setUpConditionImage()
        setUpBottombackgroundView()
        setUpHourlyCollectionView()
        setUpAdditionalStackView()
        setUpWeeklyTableViewHeightConstraint()
    }

    private func setUpAdditionalStackView() {
        springConstraint = NSLayoutConstraint(item: extraContentStackView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: hourlyCollectionView,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: Grid.pt64)
        springConstraint.isActive = true
        extraContentStackView.leadingAnchor.constraint(equalTo: secondScreenPartBackground.leadingAnchor,
                                                       constant: Grid.pt20).isActive = true
        extraContentStackView.trailingAnchor.constraint(equalTo: secondScreenPartBackground.trailingAnchor,
                                                        constant: -Grid.pt20).isActive = true
        extraContentStackView.bottomAnchor.constraint(equalTo: secondScreenPartBackground.bottomAnchor,
                                                      constant: -springDefaultConstant).isActive = true
    }

    private func setLabelsAndImages(with newData: WeatherModel) {
        let conditionImageName = WeatherModel.getConditionNameBy(conditionId: newData.conditionId)
        
        let backgroundColors = colorThemeComponent.colorTheme.cityDetails.screenBackground
        let inheritedIconColor = colorThemeComponent.colorTheme.getColorByConditionId(newData.conditionId).iconsColor
        let imageColor = backgroundColors.ignoreColorInheritance ? backgroundColors.mainIconColor : inheritedIconColor
        
        let imageBuilder = ConditionImageBuilder()
        conditionImage.image = imageBuilder
            .erase(.onlyWhite)
            .build(systemImageName: conditionImageName, pointConfiguration: Grid.pt20)
            .buildColor(imageColor)
            .content

        tempLebel.text = newData.temperatureString

        let feelsLikeDescriptionString = newData.description.prefix(1).capitalized + newData.description.dropFirst()
        descriptionLabel.text = feelsLikeDescriptionString

        feelsLikeLabel.text = newData.feelsLikeString

        weeklyForecastTableView.reloadData(newData)
        weatherQualityInfoView.setupValues(weatherData: newData)
    }

    private func updateDisplayData(with newData: WeatherModel) {
        setLabelsAndImages(with: newData)
        weeklyForecastTableView.reloadData(newData)
        hourlyCollectionView.collectionView.reloadData()
        weatherQualityInfoView.setupValues(weatherData: newData)

        localWeatherData = newData
    }

    // MARK: - Actions

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
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
            return
        }
        
        // Check if CollectionView is currently scrolling and break if so
        if hourlyCollectionView.collectionView.isDragging ||
            hourlyCollectionView.collectionView.isDecelerating { return }

        // Handle navigation bar appearance according to the scroll view offset
        let targetHeight = (topTranslucentBackground.bounds.height - degreeStackView.bounds.height)
            / 2 - navigationBarBlurBackground.bounds.height
        // Calculate how much has been scrolled relative to the target
        let offset = scrollView.contentOffset.y / targetHeight
        navigationBarBlurBackground.alpha = offset

        // Spring constant will change its value by scrolling to half of its size
        let oldConstant = hourlyTopConstant
        let newConstant: CGFloat = scrollView.contentOffset.y < hourlyTopConstant / 2 ? springDefaultConstant : Grid.pt24

        if oldConstant != newConstant {
            UIView.animate(withDuration: 0.1) {
                self.springConstraint.constant = newConstant
                self.view.layoutIfNeeded()
            }
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
        let alert = AlertViewBuilder()
            .build(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
            .build(title: "Ok", style: .default, handler: nil)
            .content
        
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - SetUp constraints

extension CityDetailViewController {
    private func setUpConditionImage() {
        conditionImage.widthAnchor.constraint(equalToConstant: Grid.pt152).isActive = true
        conditionImage.heightAnchor.constraint(equalToConstant: Grid.pt152).isActive = true
    }

    private func setUpWeeklyTableViewHeightConstraint() {
        weeklyTableViewHightConstraint = NSLayoutConstraint(item:
                                                                weeklyForecastTableView.tableView,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .height,
                                                            multiplier: 1,
                                                            constant: 0)
        weeklyTableViewHightConstraint.isActive = true
    }

    private func setUpDegreeStackView() {
        degreeStackView.centerYAnchor.constraint(equalTo: topTranslucentBackground.centerYAnchor).isActive = true
        degreeStackView.centerXAnchor.constraint(equalTo: topTranslucentBackground.centerXAnchor).isActive = true
    }

    private func setUpBottombackgroundView() {
        secondScreenPartBackground.topAnchor.constraint(equalTo: topTranslucentBackground.bottomAnchor).isActive = true
        secondScreenPartBackground.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
        secondScreenPartBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        secondScreenPartBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
    }

    private func setUpTopTranslucentView() {
        topTranslucentBackground.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        topTranslucentBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        topTranslucentBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        topTranslucentBackground.heightAnchor.constraint(equalToConstant:
                                                            UIScreen.main.bounds.height - hourlyForecastHeightConstant -
                                                         hourlyTopConstant - Grid.pt40).isActive = true
    }

    private func setUpScrollView() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setUpNavBar() {
        navigationBarBlurBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBarBlurBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBarBlurBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let navBarSize = navigationController?.navigationBar.bounds ?? CGRect.zero
        let statusBarSize = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        let overallNavBarHeight = navBarSize.height + statusBarSize.height
        navigationBarBlurBackground.heightAnchor.constraint(equalToConstant: overallNavBarHeight).isActive = true
    }

    private func setUpScrollContentView() {
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setUpHourlyCollectionView() {
        hourlyCollectionView.leadingAnchor.constraint(equalTo: secondScreenPartBackground.leadingAnchor).isActive = true
        hourlyCollectionView.trailingAnchor.constraint(equalTo: secondScreenPartBackground.trailingAnchor).isActive = true

        hourlyHeightConstraint = NSLayoutConstraint(item: hourlyCollectionView,
                                                    attribute: .height, relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .height,
                                                    multiplier: 0,
                                                    constant: hourlyForecastHeightConstant)
        hourlyCollectionView.addConstraint(hourlyHeightConstraint)
        hourlyCollectionView.heightAnchor.constraint(equalToConstant: hourlyForecastHeightConstant).isActive = true
        hourlyCollectionView.topAnchor.constraint(equalTo: secondScreenPartBackground.topAnchor,
                                                  constant: hourlyTopConstant).isActive = true
    }

    private func setupBlurableNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationBarBlurBackground.alpha = 0
    }

    private func setupGradientBackground() {
        let cityDetails = colorThemeComponent.colorTheme.cityDetails
        gradientBackground.startPoint = cityDetails.screenBackground.gradient.startPoint
        gradientBackground.endPoint = cityDetails.screenBackground.gradient.endPoint
        
        let backgroundColors = cityDetails.screenBackground
        let currentWeatherColors = colorThemeComponent.colorTheme.getColorByConditionId(localWeatherData?.conditionId ?? 0).colors
        let uiColors = backgroundColors.ignoreColorInheritance ? backgroundColors.colors : currentWeatherColors
        
        var cgColors: [CGColor] = []
        for uiColor in uiColors {
            cgColors.append(uiColor.cgColor)
        }
        
        if let firstColor = cgColors.first, cgColors.count == 1 {
            cgColors.append(firstColor)
        }
        
        gradientBackground.colors = cgColors
        self.view.layer.insertSublayer(gradientBackground, at: 0)
    }
}
