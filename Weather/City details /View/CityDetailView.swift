//
//  CityDetailView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 11.12.2021.
//

import UIKit

protocol CityDetailViewProtocol: UIView {
    func updateData(_ weatherModel: WeatherModel)
    func viewWillLayoutUpdate()
}

class CityDetailView: UIView, CityDetailViewProtocol {

    // MARK: - Public properties

    weak var viewControllerOwner: CityDetailViewControllerDelegate?
    var colorThemeComponent: ColorThemeProtocol

    // MARK: - Private properties
    
    private lazy var navigationBarBlurBackground: UIVisualEffectView = {
        let isNavBarDark = colorThemeComponent.colorTheme.cityDetails.isNavBarDark
        let view = UIVisualEffectView(effect: UIBlurEffect(style: isNavBarDark ? .dark : .light))
        view.alpha = 0
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

    // MARK: - Screen first part

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
    
    private lazy var arrowHint: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.compact.up") ?? UIImage()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Screen second part

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
    
    // Constraints
    private let hourlyForecastHeightConstant: CGFloat = Grid.pt100
    private var hourlyTopConstant: CGFloat = Grid.pt8
    private let springDefaultConstant: CGFloat = Grid.pt52

    private var hourlyHeightConstraint = NSLayoutConstraint()
    private var weeklyTableViewHightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var springConstraint: NSLayoutConstraint = NSLayoutConstraint()

    // Background views
    private var weeklyTableBackground: UIView = UIView()
    private let gradientBackground = CAGradientLayer()

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)

        scrollView.delegate = self
        
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(topTranslucentBackground)
        
        let backgroundColors = colorThemeComponent.colorTheme.cityDetails.screenBackground
        tempLebel.textColor = backgroundColors.labelsColor
        descriptionLabel.textColor = backgroundColors.labelsColor
        feelsLikeLabel.textColor = backgroundColors.labelsColor
        degreeStackView.addArrangedSubview(conditionImage)
        degreeStackView.addArrangedSubview(tempLebel)
        degreeStackView.addArrangedSubview(descriptionLabel)
        degreeStackView.addArrangedSubview(feelsLikeLabel)
        topTranslucentBackground.addSubview(degreeStackView)
        
        topTranslucentBackground.addSubview(arrowHint)

        scrollContentView.addSubview(secondScreenPartBackground)
        secondScreenPartBackground.addSubview(hourlyCollectionView)
        
        extraContentStackView.addArrangedSubview(weeklyForecastTableView)
        extraContentStackView.addArrangedSubview(weatherQualityInfoView)
        secondScreenPartBackground.addSubview(extraContentStackView)
        
        addSubview(navigationBarBlurBackground)
        
        setupGradientBackground()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func viewWillLayoutUpdate() {
        // Set tableview height according to its contents
        weeklyTableViewHightConstraint.constant = weeklyForecastTableView.tableView.contentSize.height
        gradientBackground.frame = bounds
        scrollView.contentSize = scrollContentView.bounds.size
        
        setUpNavBar()
    }
    
    func updateData(_ weatherModel: WeatherModel) {
        setLabelsAndImages(with: weatherModel)
        weeklyForecastTableView.reloadData(weatherModel)
        hourlyCollectionView.dataSource = weatherModel
        hourlyCollectionView.collectionView.reloadData()
        weatherQualityInfoView.setupValues(weatherData: weatherModel)
    }

    // MARK: - Private Functions
    
    private func setupActivatedArrowHint(_ isActivated: Bool) {
            let arrowDown = UIImage(systemName: "chevron.compact.down") ?? UIImage()
            let arrowUp = UIImage(systemName: "chevron.compact.up") ?? UIImage()
            arrowHint.image = isActivated ? arrowDown : arrowUp
        }

    private func updateAlphaViews() {
        // Handle navigation bar appearance according to the scroll view offset
        let targetHeight = (topTranslucentBackground.bounds.height - degreeStackView.bounds.height)
            / 2 - navigationBarBlurBackground.bounds.height
        // Calculate how much has been scrolled relative to the target
        let offset = scrollView.contentOffset.y / targetHeight
        navigationBarBlurBackground.alpha = offset
    }

    private func updateAnimatedViews() {
        // Spring constant will change its value by scrolling to half of its size
        let oldConstant = hourlyTopConstant
        let newConstant: CGFloat
        let activateArrowHint: Bool

        if scrollView.contentOffset.y < hourlyTopConstant / 2 {
            newConstant = springDefaultConstant
            activateArrowHint = false
        } else {
            newConstant = Grid.pt24
            activateArrowHint = true
        }

        if oldConstant != newConstant {
            UIView.animate(withDuration: 0.1) {
                self.setupActivatedArrowHint(activateArrowHint)
                self.springConstraint.constant = newConstant
                self.layoutIfNeeded()
            }
        }
    }

    private func setUpConstraints() {
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
    
    private func setUpNavBar() {
        navigationBarBlurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        navigationBarBlurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navigationBarBlurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        let navBarHeight = viewControllerOwner?.getNavigationBar()?.bounds.height ?? 0
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let overallNavBarHeight = navBarHeight + statusBarHeight
        
        navigationBarBlurBackground.heightAnchor.constraint(equalToConstant: overallNavBarHeight).isActive = true
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
}

// MARK: - ScrollView

extension CityDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
            return
        }

        updateAlphaViews()
        
        let hourlyCollectionView = hourlyCollectionView.collectionView
        guard !hourlyCollectionView.isDragging && !hourlyCollectionView.isDecelerating else {
            return
        }

        updateAnimatedViews()
    }
}

// MARK: - SetUp constraints

extension CityDetailView {
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
        arrowHint.heightAnchor.constraint(equalToConstant: Grid.pt40).isActive = true
        arrowHint.widthAnchor.constraint(equalToConstant: Grid.pt40).isActive = true
        arrowHint.bottomAnchor.constraint(equalTo: topTranslucentBackground.bottomAnchor, constant: -Grid.pt12).isActive = true
        arrowHint.centerXAnchor.constraint(equalTo: topTranslucentBackground.centerXAnchor).isActive = true
        
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
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
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

    private func setupGradientBackground() {
        let cityDetails = colorThemeComponent.colorTheme.cityDetails
        gradientBackground.startPoint = cityDetails.screenBackground.gradient.startPoint
        gradientBackground.endPoint = cityDetails.screenBackground.gradient.endPoint
        
        let backgroundColors = cityDetails.screenBackground
        let currentWeatherColors = colorThemeComponent.colorTheme.getColorByConditionId(0).colors
        let uiColors = backgroundColors.ignoreColorInheritance ? backgroundColors.colors : currentWeatherColors
        
        var cgColors: [CGColor] = []
        for uiColor in uiColors {
            cgColors.append(uiColor.cgColor)
        }
        
        if let firstColor = cgColors.first, cgColors.count == 1 {
            cgColors.append(firstColor)
        }
        
        gradientBackground.colors = cgColors
        layer.insertSublayer(gradientBackground, at: 0)
    }
}
