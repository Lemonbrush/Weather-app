//
//  UnitsSettingsCellController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 27.11.2021.
//

import Foundation

class UnitsSettingsCellController: ReloadColorThemeProtocol {

    // MARK: - Properties
    
    let cell: UnitsSettingsCell

    var viewControllerOwner: SettingsViewControllerDelegate?
    
    // MARK: - Private properties
    
    let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        cell = UnitsSettingsCell(colorThemeComponent: colorThemeComponent)
        cell.delegate = self
    }
    
    // MARK: - Functions

    func reloadColorTheme() {
        cell.reloadColorTheme()
    }
}

extension UnitsSettingsCellController: UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int) {
        switch value {
        case 0:
            UserDefaultsManager.UnitData.set(with: K.UserDefaults.metric)
        case 1:
            UserDefaultsManager.UnitData.set(with: K.UserDefaults.imperial)
        default:
            break
        }
        
        viewControllerOwner?.refreshMainMenu()
    }
}
