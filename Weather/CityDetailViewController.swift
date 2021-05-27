//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Александр on 06.04.2021.
//

import UIKit

class CityDetailViewController: UIViewController {
    
    @IBOutlet weak var weekForecast: UITableView!
    @IBOutlet weak var tableHight: NSLayoutConstraint!
    @IBOutlet weak var whiteBackgroundView: NSLayoutConstraint!
    @IBOutlet weak var hourlyForecastHeight: NSLayoutConstraint!
    @IBOutlet weak var hourlySpringConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var transparentTopBAckground: UIView!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var weeklyTableBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    
    let gradientBackground = CAGradientLayer()
    let navigationBarBlurBackground = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        //Set tableview height according to its contents
        tableHight.constant = weekForecast.contentSize.height
        
        //Calculate gradient size
        gradientBackground.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Adjast view so that hourly forecast only could be seen at the bottom
        whiteBackgroundView.constant = view.frame.height - (hourlyForecastHeight.constant + hourlySpringConstraint.constant)
    }
    
    //MARK: - Helper functions
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CityDetailViewController: UIScrollViewDelegate {
    
    //Calls on scrolling scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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

extension CityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TODO: here should be weekly forecast
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
}
