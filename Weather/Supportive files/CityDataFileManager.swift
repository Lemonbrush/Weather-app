//
//  CityDataFileManager.swift
//  Weather
//
//  Created by Александр on 22.04.2021.
//

import Foundation

struct CityDataFileManager {
    
    static let fileManager = FileManager()
    
    static func addNewCity(_ city: String) {
        
        var dataToSave = getSavedCities() ?? [String]()
        
        dataToSave.append(city)
        
        saveCities(dataToSave as NSArray)
    }
    
    static func swapCities(atRow firstCity: Int, and secondCity: Int) {
        guard var cities = getSavedCities() else {
            return
        }
        
        cities.swapAt(firstCity, secondCity)
        
        saveCities(cities as NSArray)
    }
    
    static func getSavedCities() -> [String]? {
        
        guard let url = makeURL(forFileNamed: K.saveFileName) else {
            print("Failed to get directory to save files")
            return nil
        }
        
        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        //print(url.absoluteURL)
        return NSArray(contentsOf: url) as? [String]
    }
    
    // MARK: - Helper functions
    
    private static func makeURL(forFileNamed fileName: String) -> URL? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(fileName)
    }
    
    static func saveCities(_ dataToSave: NSArray) {
            
            guard let url = makeURL(forFileNamed: K.saveFileName) else {
                print("Failed to get directory to save files")
                return
            }
            
            dataToSave.write(to: url, atomically: true)
        }
}
