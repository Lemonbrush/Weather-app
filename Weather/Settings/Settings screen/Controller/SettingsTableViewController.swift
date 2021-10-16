//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Александр on 20.06.2021.
//

import UIKit

struct SettingsSection {
    var title: String?
    var cells: [UITableViewCell]
}

class SettingsViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let unitsSettingsCell = UnitsSettingsCell()
    private lazy var colorThemeSettingsCell = ColorThemeSettingsCell()
    
    private let mainView = SettingsView()

    // MARK: - Public properties

    var mainMenuDelegate: MainMenuDelegate?
    var colorThemeComponent: ColorThemeProtocol

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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        
        unitsSettingsCell.delegate = self
        colorThemeSettingsCell.delegate = self
        colorThemeSettingsCell.colorThemeComponent = colorThemeComponent
        colorThemeSettingsCell.refresh()
        
        let appSettingsSection = SettingsSection(title: "APP",
                                                 cells: [unitsSettingsCell,
                                                         colorThemeSettingsCell])
        
        mainView.settingsSections?.append(appSettingsSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorThemeSettingsCell.refresh()
    }
}

extension SettingsViewController: UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int) {
        switch value {
        case 0:
            UserDefaultsManager.setUnitData(with: K.UserDefaults.metric)
        case 1:
            UserDefaultsManager.setUnitData(with: K.UserDefaults.imperial)
        default:
            break
        }
        
        mainMenuDelegate?.fetchWeatherData()
    }
}

extension SettingsViewController: ColorThemeSettingsCellDelegste {
    func presentColorThemes() {
        let colorThemeSettingsViewController = ColorThemeSettingsViewController(colorThemeComponent: colorThemeComponent)
        colorThemeSettingsViewController.mainMenuDelegate = mainMenuDelegate
        colorThemeSettingsViewController.colorThemeComponent = colorThemeComponent
        
        navigationController?.pushViewController(colorThemeSettingsViewController,
                                                 animated: true)
    }
}
