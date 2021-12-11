//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Александр on 06.04.2021.
//

import UIKit

protocol CityDetailViewControllerDelegate: AnyObject {
    func getNavigationBar() -> UINavigationBar?
    func updateBluredNavBarTargetHeight(_ height: CGFloat)
}

class CityDetailViewController: UIViewController, CityDetailViewControllerDelegate {

    // MARK: - Public properties
    
    
    var localWeatherData: WeatherModel?
    var colorThemeComponent: ColorThemeProtocol
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .darkContent : .lightContent
    }

    // MARK: - Private properties
    
    private lazy var navigationBarBlurBackground: UIVisualEffectView = {
        let isNavBarDark = colorThemeComponent.colorTheme.cityDetails.isNavBarDark
        let view = UIVisualEffectView(effect: UIBlurEffect(style: isNavBarDark ? .dark : .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainView: CityDetailViewProtocol = {
        let view = CityDetailView(colorThemeComponent: colorThemeComponent)
        view.viewControllerOwner = self
        return view
    }()
    
    private lazy var backButtonNavBarItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonPressed))
        button.tintColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .black : .white
        
        return button
    }()
    
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
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navigationBarBlurBackground)
        
        backButtonNavBarItem.action = #selector(backButtonPressed)
        backButtonNavBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonNavBarItem

        weatherManager.delegate = self

        if let safeWeatherData = localWeatherData {
            let navBarTitleColor: UIColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .black : .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTitleColor]
            title = safeWeatherData.cityName
            
            mainView.updateData(safeWeatherData)
        }

        updateTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                           target: self,
                                           selector: #selector(fetchWeatherData),
                                           userInfo: nil,
                                           repeats: true)
        updateTimer?.fire()
        
        setUpNavBar()
        setupBlurableNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.setupNavBarSizes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    // MARK: - Functions
    
    func getNavigationBar() -> UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    func updateBluredNavBarTargetHeight(_ height: CGFloat) {
        navigationBarBlurBackground.alpha = height
    }
    
    // MARK: - Private Functions
    
    private func setUpNavBar() {
        navigationBarBlurBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBarBlurBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBarBlurBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let navBarHeight = getNavigationBar()?.bounds.height ?? 0
        let statusBarHeight = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let overallNavBarHeight = navBarHeight + statusBarHeight
        
        navigationBarBlurBackground.heightAnchor.constraint(equalToConstant: overallNavBarHeight).isActive = true
    }
    
    private func setupBlurableNavBar() {
        getNavigationBar()?.shadowImage = UIImage()
        getNavigationBar()?.setBackgroundImage(UIImage(), for: .default)
        getNavigationBar()?.backgroundColor = .clear
        navigationBarBlurBackground.alpha = 0
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

extension CityDetailViewController: NetworkManagerDelegate {
    func didUpdateWeather(_ weatherManager: NetworkManager, weather: WeatherModel, at position: Int) {
        DispatchQueue.main.async {
            self.mainView.updateData(weather)
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

