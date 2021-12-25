//
//  ColorThemeSettingsCellController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 27.11.2021.
//

import Foundation
import UIKit

class ColorThemeSettingsCellController: ReloadColorThemeProtocol {

    // MARK: - Properties
    
    let cell: ColorThemeSettingsCell

    var viewControllerOwner: SettingsViewControllerDelegate?
    
    var reloadingViews: [ReloadColorThemeProtocol] = []
    
    // MARK: - Private properties
    
    let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        cell = ColorThemeSettingsCell(colorThemeComponent: colorThemeComponent)
        cell.delegate = self
    }
    
    // MARK: - Functions

    func reloadColorTheme() {
        cell.reloadColorTheme()
        cell.refresh()
    }
}

extension ColorThemeSettingsCellController: ColorThemeSettingsCellDelegste {
    func presentColorThemes() {
        let colorThemeSettingsViewController = ColorThemeSettingsViewController(colorThemeComponent: colorThemeComponent)
        reloadingViews.append(self)
        reloadingViews.append(colorThemeSettingsViewController)
        
        colorThemeSettingsViewController.reloadingViews = reloadingViews
        
        viewControllerOwner?.navigationController?.pushViewController(colorThemeSettingsViewController, animated: true)
    }
}
