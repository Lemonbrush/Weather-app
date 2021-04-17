//
//  ViewController.swift
//  CityListDBCreator
//
//  Created by Александр on 15.04.2021.
//

import CoreData
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cities: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        
        tableView.reloadData()
    }

    @IBAction func populateButtonPressed(_ sender: UIButton) {
        
        var testM = CityManager()
        var cityList = testM.getCityList()!
        
        for (i, city) in cityList.enumerated() {
            print(city.cityName," - ",city.id)
            
            self.save(name: city.cityName,
                      cID: city.countryID,
                      cName: city.countryName,
                      id: city.id,
                      state: city.state)
        }
        
    }
    
    @IBAction func deleteDB(_ sender: Any) {
        delete(name: "City")
        tableView.reloadData()
    }
    
    //CoreData methods
    func save(name: String, cID: String, cName: String, id: Int, state: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        
        city.setValue(name, forKeyPath: "cityName")
        city.setValue(cID, forKeyPath: "countryId")
        city.setValue(cName, forKeyPath: "countryName")
        city.setValue(id, forKeyPath: "id")
        city.setValue(state, forKeyPath: "state")
        
        do {
            try managedContext.save()
            cities.append(city)
        } catch {
            print(error)
        }
    }
    
    func delete(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let delAll = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "City"))
        
        do {
            try managedContext.execute(delAll)
        } catch {
            print(error)
        }
    }
    
}

//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = cities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        let cityName = city.value(forKeyPath: "cityName") as! String
        let countryID = city.value(forKeyPath: "countryId") as! String
        let countryName = city.value(forKeyPath: "countryName") as! String
        let id = city.value(forKeyPath: "id") as! Int
        let state = city.value(forKeyPath: "state") as! String
        
        cell.textLabel?.text = "\(cityName) \n\(countryName) (\(countryID)) \nid: \(id) \nstate: \(state)"
        
        return cell
    }
    
}

