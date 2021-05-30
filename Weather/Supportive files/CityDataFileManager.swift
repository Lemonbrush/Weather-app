//
//  CityDataFileManager.swift
//  Weather
//
//  Created by Александр on 22.04.2021.
//

import Foundation

struct SavedCity: Codable {
    let position: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

struct CityDataFileManager {
    
    static let fileManager = FileManager()
    
    static func addNewCity(_ city: String, lat: Double, long: Double) {
        
        var dataToSave = getSavedCities() ?? [SavedCity]()
        
        let newCity = SavedCity(position: dataToSave.count, name: city, latitude: lat, longitude: long)
        
        dataToSave.append(newCity)
        
        saveCities(dataToSave as [SavedCity])
    }
    
    static func swapCities(atRow firstCity: Int, and secondCity: Int) {
        guard var cities = getSavedCities() else {
            return
        }
        
        cities.swapAt(firstCity, secondCity)
        
        saveCities(cities)
    }
    
    static func getSavedCities() -> [SavedCity]? {
        
        guard let url = makeURL(forFileNamed: K.saveFileName) else {
            print("Failed to get directory to save files")
            return nil
        }
        
        guard fileManager.fileExists(atPath: url.path) else {
            print("File does not exist yet")
            return nil
        }
        
        print(url.absoluteURL)
        
        //Decode and return data
        let decoder = JSONDecoder()
        if let loadedData = try? decoder.decode([SavedCity].self, from: Data(contentsOf: url)) {
            return loadedData
        }
        
        return nil
    }
    
    // MARK: - Helper functions
    
    private static func makeURL(forFileNamed fileName: String) -> URL? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(fileName)
    }
    
    static func saveCities(_ dataToSave: [SavedCity]) {
            
        guard let url = makeURL(forFileNamed: K.saveFileName) else {
            print("Failed to get directory to save files")
            return
        }
        
        //Encode and save data as JSON
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dataToSave) {
            
            do {
                try encoded.write(to: url)
            } catch {
                print("Error encoding file to save")
            }
        }
    }
}
