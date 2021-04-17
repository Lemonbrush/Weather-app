//
//  CityManager.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import Foundation

struct CityManager {
    
    mutating func getCityList() -> [CityModel]? {
        
        if let localData = self.readFile("CityList"), let cityList = self.parse(jsonData: localData) {
            return cityList
        }
        
        return nil
    }
    
    //Helper functions
    private func readFile(_ fileName: String) -> Data? {
        
        do {
            
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
            
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private mutating func parse(jsonData: Data) -> [CityModel]? {
        
        do {
            let decodedData = try JSONDecoder().decode([CityData].self, from: jsonData)
            
            var cityList = [CityModel]()
            
            let CountryCodes = getCountryCodesDict() //Country codes dictioonary for getting the Country names
            
            for city in decodedData {
                
                let newCity = CityModel(id: city.id,
                                        state: city.state,
                                        countryID: city.country,
                                        cityName: city.name,
                                        countryName: CountryCodes[city.country] ?? "")
                cityList.append(newCity)
            }
            
            return cityList
            
        } catch {
            print("Decode error - \(error)")
        }
        
        return nil
    }
    
    //MARK: - City code convertor functions
    func getCityCodeWithNames() -> [CityCodeData]? {
        
        if let localData = self.readFile("CityCodesList") {
            
            do {
                let decodedData = try JSONDecoder().decode([CityCodeData].self, from: localData)
                
                return decodedData
                
            } catch {
                print("Failed to parse city code list", error)
            }
            
            return nil
        }
        
        return nil
    }
    
    mutating func getCountryCodesDict() -> [String : String] {
        
        var countryCodeList = [String : String]()
        
        let countryCodes = getCityCodeWithNames()
        
        for city in countryCodes! {
            countryCodeList[city.Code] = city.Name
        }
        
        return countryCodeList
    }
}

