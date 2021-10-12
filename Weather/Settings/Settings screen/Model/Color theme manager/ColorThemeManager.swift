//
//  ColorThemeManager.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import Foundation

struct ColorThemeManager {
    
    // MARK: - Public functions
    
    static func getColorThemes() -> [ColorThemeModel]? {
        guard let colorThemesFile = readLocalFile(forName: "ColorThemes"),
              let result = parseJSON(colorThemesFile) else {
                  
            return nil
        }
        
        return result
    }
    
    // MARK: - Private functions
    
    static private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static private func parseJSON(_ colorThemeData: Data) -> [ColorThemeModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([ColorThemeData].self, from: colorThemeData)
            var result: [ColorThemeModel] = []
            for colorTheme in decodedData {
                result.append(ColorThemeModel(colorThemeData: colorTheme))
            }
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
