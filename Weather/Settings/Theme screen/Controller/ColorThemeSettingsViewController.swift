//
//  ThemeSettingsViewController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ColorThemeSettingsViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = ColorThemeSettingsView(colorThemes: ColorThemeManager.getColorThemes())
    
    // MARK: - Public properties
    
    var colorThemeComponent: ColorThemeProtocol
    var mainMenuDelegate: MainMenuDelegate?
    
    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.viewControllerOwner = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Color theme"
    }
    
    // MARK: - Public properties
    
    func refreshCurrentColorThemeSettingsCell(colorThemePosition: Int) {
        colorThemeComponent.colorTheme = UserDefaultsManager.ColorTheme.getColorTheme(colorThemePosition)
        mainMenuDelegate?.reloadTable()
    }
}
