//
//  AppIconSettingsCellController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 27.11.2021.
//

import Foundation

class AppIconSettingsCellController: ReloadColorThemeProtocol {

    // MARK: - Private
    
    lazy var cell = AppIconSettingsCell(colorThemeComponent: colorThemeComponent,
                                   appIconsData: [.classic,
                                                  .darkWhiteCloudAppIcon,
                                                  .whiteSunAppIcon,
                                                  .cornerSun,
                                                  .orangeCloud,
                                                  .moon,
                                                  .yellowSun,
                                                  .blueWhiteCloud],
                                   chosenIconNum: getCurrentAppIconPosition())
    let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        cell.delegate = self
    }
    
    // MARK: - Functions
    
    
    func reloadColorTheme() {
        cell.reloadColorTheme()
    }
}

extension AppIconSettingsCellController: AppIconSettingsCellDelegate {
    func getCurrentAppIconPosition() -> Int {
        return UserDefaultsManager.AppIcon.get()
    }
    
    func changeAppIcon(_ appIconModel: BMAppIcon) {
        UserDefaultsManager.AppIcon.set(with: appIconModel.rawValue)
        AppIconManager().setIcon(appIconModel)
    }
}
