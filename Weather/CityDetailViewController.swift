//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Александр on 06.04.2021.
//

import UIKit

class CityDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        let testM = CityManager()
        let cityList = testM.getCityList()!
        
        for city in cityList {
            print(city.cityName)
        }
        
        print(cityList.count)
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */
}
