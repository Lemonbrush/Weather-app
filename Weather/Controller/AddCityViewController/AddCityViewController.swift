//
//  AddCityViewController.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController {

    @IBOutlet weak var searchCellBackground: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var welcomeImage: UIImageView!
    
    var cities: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up search cell appearance
        searchCellBackground.layer.cornerRadius = 10
        searchCellBackground.layer.cornerCurve = CALayerCornerCurve.continuous
        
        //Connect Search textField to the textFieldDidChange method
        searchBar.addTarget(self, action: #selector(AddCityViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CoreData helper functions
    
    func loadCityList(with request: NSFetchRequest<City> = City.fetchRequest(),
                      predicate: NSPredicate? = nil) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate])
        }
        
        do {
            cities = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        searchResultsTable.reloadData()
    }
    
    // MARK: - TextField methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            
            welcomeImage.isHidden = true
            
            let request: NSFetchRequest<City> = City.fetchRequest() //Specify data type for search
            let predicate = NSPredicate(format: "cityName BEGINSWITH[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: false)]
            
            loadCityList(with: request, predicate: predicate)
            
        } else {
            
            //Clear the table in case of empty search bar
            cities.removeAll()
            searchResultsTable.reloadData()
            welcomeImage.isHidden = false
        }
    }
    
    // MARK: - Helper functions
    
    //Country id to country emoji flag converter
    func countryFlag(byCode code: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return String(s)
    }

}

// MARK: - TableView methods

extension AddCityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let cityToShow = cities[indexPath.row]
        let cityName = cityToShow.value(forKey: "cityName") as! String
        let cityCountry = cityToShow.value(forKey: "countryName") as! String
        let cityState = cityToShow.value(forKey: "state") as! String
        let cityCode = cityToShow.value(forKey: "countryId") as! String
        
        cell.textLabel?.text = "\(countryFlag(byCode: cityCode)) \(cityName), \(cityCountry)"
        
        //In case there is a state note
        if cityState != "" {
            cell.textLabel?.text! += ", \(cityState)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension AddCityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //Handle cell selecting
        
        let cityFileManager = CityDataFileManager()
        try! cityFileManager.addNewCity("Moscow")
        print(try! cityFileManager.getSavedCities())
    }
}
