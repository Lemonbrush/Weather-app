//
//  AddCityViewController.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var cities: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up search bar appearance
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        
        do {
            cities = try managedContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        //Delete this. Just a test
        for (i, city) in cities.enumerated()  {
            if i <= 100 {
                print(city.value(forKey: "cityName")!)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
