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
    
    private let mainView = SettingsView()

    // MARK: - Public properties

    var mainMenuDelegate: MainMenuDelegate?

    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
        mainView.viewControllerOwner = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        
        unitsSettingsCell.delegate = self
        
        let appSettingsSection = SettingsSection(title: "APP", cells: [unitsSettingsCell])
        
        mainView.settingsSections?.append(appSettingsSection)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainMenuDelegate?.fetchWeatherData()
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
    }
}
