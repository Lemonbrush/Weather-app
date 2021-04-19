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
    @IBOutlet weak var searchResultsTable: UITableView!
    
    var cities: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        //Setting up search bar appearance
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        searchResultsTable.backgroundColor = nil
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
        
        cell.textLabel?.text = "\(cityName), \(cityCountry)"
        
        if cityState != "" {
            cell.textLabel?.text! += ", \(cityState)"
        }
        
        cell.backgroundColor = nil
        
        return cell
    }
}

extension AddCityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //Handle cell selecting
    }
}

extension AddCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count != 0 {
            
            let request: NSFetchRequest<City> = City.fetchRequest() //Specify data type for search
            let predicate = NSPredicate(format: "cityName BEGINSWITH[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: false)]
            
            loadCityList(with: request, predicate: predicate)
            
        } else {
            
            //Clear the table in case of empty search bar
            cities.removeAll()
            searchResultsTable.reloadData()
        }
    }
}
