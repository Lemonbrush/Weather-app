//
//  ViewController.swift
//  CityListDBCreator
//
//  Created by Александр on 15.04.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func populateButtonPressed(_ sender: UIButton) {
        
        let testM = CityManager()
        let cityList = testM.getCityList()!
        
        for city in cityList {
            print(city.cityName)
        }
        
        print(cityList.count)
        
    }
    
}

