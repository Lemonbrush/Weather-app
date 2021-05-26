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
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var hourlySpringConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var weeklyTableBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    let gradientBackground = CAGradientLayer()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarClearAppearance()
        
        //Setting up gradint background
        gradientBackground.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientBackground.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientBackground.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientBackground.colors = DesignManager.getStandartGradientColor(withStyle: .day)
        self.view.layer.insertSublayer(gradientBackground, at: 0)
        
        scrollView.delegate = self
        
        //Set up background shapes
        DesignManager.setBackgroundStandartShape(layer: weeklyTableBackground.layer)
        DesignManager.setBackgroundStandartShape(layer: humidityBackground.layer)
        
        //Set up background shadows
        DesignManager.setBackgroundStandartShadow(layer: weeklyTableBackground.layer)
        DesignManager.setBackgroundStandartShadow(layer: humidityBackground.layer)
        
        //Getting rid of the gap at the bottom - header view begins under the navigation bar
        scrollView.contentInsetAdjustmentBehavior = .never
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
    
    private func setNavigationBarClearAppearance() {
        navigationController?.navigationBar.barStyle = UIBarStyle.default
    }
    
    private func setNavigationBarBlurAppearance() {
        navigationController?.navigationBar.barStyle = UIBarStyle.black
    }
}

extension CityDetailViewController: UIScrollViewDelegate {
    
    //Calls on scrolling scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= (navigationController?.navigationBar.frame.height)! {
            setNavigationBarBlurAppearance()
        } else {
            setNavigationBarClearAppearance()
        }
        
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
