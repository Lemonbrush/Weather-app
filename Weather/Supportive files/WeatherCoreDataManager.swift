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

protocol DataStorageBasicProtocol {
    var getSavedItems: [SavedCity]? { get }
    func deleteItem(at index: Int)
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int)
    func addNewItem(_ city: String, lat: Double, long: Double)
}

protocol DataStorageProtocol: DataStorageBasicProtocol {
    var managedContext: NSManagedObjectContext { get set }
}

class WeatherCoreDataManager: DataStorageProtocol {
    
    //MARK: - Public properties
    
    internal var managedContext: NSManagedObjectContext
    
    var getSavedItems: [SavedCity]? {
        guard let savedCitiesEntities = getManagedObjects() else {
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
    
    //MARK: - Construction
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }

    //MARK: - Public functions
    
    func deleteItem(at index: Int) {
        guard let cityEntities = getManagedObjects() else {
            return
        }
        
        managedContext.delete(cityEntities[index])
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int) {
        guard var cityEntities = getManagedObjects() else {
            return
        }
        
        let mover = cityEntities[firstIndex]
        cityEntities.remove(at: firstIndex)
        cityEntities.insert(mover, at: secondIndex)
        
        for (index, entity) in cityEntities.enumerated() {
            entity.orderPosition = index
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not rearrange. \(error), \(error.userInfo)")
        }
    }
    
    func addNewItem(_ city: String, lat: Double, long: Double) {
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        let citySavingObject = NSManagedObject(entity: entity, insertInto: managedContext)
        citySavingObject.setValue(city, forKey: K.CoreData.City.name)
        citySavingObject.setValue(lat, forKey: K.CoreData.City.latitude)
        citySavingObject.setValue(long, forKey: K.CoreData.City.longitude)
        let cityEntitiesCount = getManagedObjects()?.count ?? 0
        citySavingObject.setValue(cityEntitiesCount, forKey: K.CoreData.City.orderPosition)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: K.CoreData.City.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete all items. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Private functions
    
    private func getManagedObjects() -> [City]? {
        //Fetch objects with order
        let fetchRequest = NSFetchRequest<City>(entityName: K.CoreData.City.entityName)
        let sortDescriptor = NSSortDescriptor(key: K.CoreData.City.orderPosition, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
          
        var entitiesToReturn: [City]?
        
        do {
            entitiesToReturn = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return entitiesToReturn
    }
}
