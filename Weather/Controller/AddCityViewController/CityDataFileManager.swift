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
    
    let fileManager = FileManager()
    
    func addNewCity(_ city: String) throws {
        
        guard let url = makeURL(forFileNamed: "savedCities") else {
            throw Error.invalidDirectory
        }
        
        if fileManager.fileExists(atPath: url.absoluteString) {
            print(url.absoluteString)
            do {
                var existingData = try getSavedCities()
            } catch {
                print("Fail to get saved cities data")
            }
            
        }
        
        do {
            try city.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            throw Error.writingFailed
        }
    }
    
    func getSavedCities() throws -> String {
        
        guard let url = makeURL(forFileNamed: "savedCities") else {
            throw Error.invalidDirectory
        }
        
        guard fileManager.fileExists(atPath: url.absoluteString) else {
            throw Error.fileNotExists
        }
        
        do {
            return try String(contentsOf: url)
        } catch {
            throw Error.readingFailed
        }
    }
    
    //Helper functions
    private func makeURL(forFileNamed fileName: String) -> URL? {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(fileName)
    }
}
