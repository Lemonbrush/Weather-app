//
//  CityDataFileManager.swift
//  Weather
//
//  Created by Александр on 22.04.2021.
//

import Foundation

struct CityDataFileManager {
    
    enum Error: Swift.Error {
        case fileAlreadyExists
        case fileNotExists
        case invalidDirectory
        case writingFailed
        case readingFailed
    }
    
    static let fileManager = FileManager()
    
    static func addNewCity(_ city: String) {
        
        guard let url = makeURL(forFileNamed: "savedCities.plist") else {
            fatalError("Failed to get directory to save files")
        }
        
        var dataToSave = [String]()
        
        if fileManager.fileExists(atPath: url.path) {
            
            do {
                dataToSave = try getSavedCities()
            } catch {
                print("Fail to get saved cities data with \(error)")
            }
        }
        
        dataToSave.append(city)
        
        (dataToSave as NSArray).write(to: url, atomically: true)
    }
    
    //Helper functions
    private static func getSavedCities() throws -> [String] {
        
        guard let url = makeURL(forFileNamed: "savedCities.plist") else {
            throw Error.invalidDirectory
        }
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw Error.fileNotExists
        }
        
        return NSArray(contentsOf: url) as! [String]
    }
    
    private static func makeURL(forFileNamed fileName: String) -> URL? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(fileName)
    }
}
