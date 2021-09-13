//
//  WeatherCoreDataManager.swift
//  Weather
//
//  Created by Alexander Rubtsov on 13.09.2021.
//

import UIKit
import CoreData

struct SavedCity: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

class WeatherCoreDataManager {
    
    //MARK: - Public functions
    
    static func deleteCity(at index: Int) {
        guard let cityEntities = getSavedCitiesManagedObjects(),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(cityEntities[index])
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    static func getSavedCities() -> [SavedCity]? {
        guard let savedCitiesEntities = getSavedCitiesManagedObjects() else {
            return nil
        }
        
        var savedCities: [SavedCity] = []
        
        for savedCityEntity in savedCitiesEntities {
            guard let name = savedCityEntity.value(forKey: K.CoreData.City.name) as? String,
                  let latitude = savedCityEntity.value(forKey: K.CoreData.City.latitude) as? Double,
                  let longitude = savedCityEntity.value(forKey: K.CoreData.City.longitude) as? Double else {
                return nil
            }
            
            let newSavedCity = SavedCity(name: name, latitude: latitude, longitude: longitude)
            savedCities.append(newSavedCity)
        }
        
        return savedCities
    }
    
    static func rearrangeCity(atRow firstCity: Int, to secondCity: Int) {
        guard var cityEntities = getSavedCitiesManagedObjects(),
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let mover = cityEntities[firstCity]
        cityEntities.remove(at: firstCity)
        cityEntities.insert(mover, at: secondCity)
        
        for (index, entity) in cityEntities.enumerated() {
            entity.orderPosition = index
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not rearrange. \(error), \(error.userInfo)")
        }
    }
    
    static func addNewCity(_ city: String, lat: Double, long: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let cityEntitiesCount = getSavedCitiesManagedObjects()?.count ?? 0
          
        let managedContext = appDelegate.persistentContainer.viewContext
          
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        
        let citySavingObject = NSManagedObject(entity: entity, insertInto: managedContext)
        citySavingObject.setValue(city, forKey: K.CoreData.City.name)
        citySavingObject.setValue(lat, forKey: K.CoreData.City.latitude)
        citySavingObject.setValue(long, forKey: K.CoreData.City.longitude)
        citySavingObject.setValue(cityEntitiesCount, forKey: K.CoreData.City.orderPosition)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Private functions
    
    static func getSavedCitiesManagedObjects() -> [City]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
          
        //Fetch objects with order
        let fetchRequest = NSFetchRequest<City>(entityName: K.CoreData.City.entityName)
        let sortDescriptor = NSSortDescriptor(key: K.CoreData.City.orderPosition, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
          
        var entitiesToReturn: [City]?
        
        do {
            entitiesToReturn = try managedContext?.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return entitiesToReturn
    }
}
