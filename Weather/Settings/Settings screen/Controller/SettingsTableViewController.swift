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

class SettingsViewController: UIViewController, ReloadColorThemeProtocol {
    
    // MARK: - Private properties
    
    private lazy var unitsSettingsCell = UnitsSettingsCell(colorThemeComponent: colorThemeComponent)
    private lazy var colorThemeSettingsCell = ColorThemeSettingsCell(colorThemeComponent: colorThemeComponent)
    private lazy var appIconSettingsCell = AppIconSettingsCell(colorThemeComponent: colorThemeComponent,
                                                               appIconsData: [.classic,
                                                                              .darkWhiteCloudAppIcon,
                                                                              .whiteSunAppIcon,
                                                                              .cornerSun,
                                                                              .orangeCloud,
                                                                              .moon,
                                                                              .yellowSun,
                                                                              .blueWhiteCloud],
                                                               chosenIconNum: getCurrentAppIconPosition())
    private lazy var telegramChatSupportCell = TelegramChatSupportCell(colorThemeComponent: colorThemeComponent)
    
    private lazy var mainView = SettingsView(colorTheme: colorThemeComponent)

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
        
        reloadColorTheme()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        unitsSettingsCell.delegate = self
        colorThemeSettingsCell.delegate = self
        appIconSettingsCell.delegate = self
        telegramChatSupportCell.delegate = self
        
        let appSettingsSection = SettingsSection(title: "APP",
                                                 cells: [unitsSettingsCell,
                                                         colorThemeSettingsCell])
        
        let appIconSection = SettingsSection(title: "APP ICON",
                                                 cells: [appIconSettingsCell])
        
        let supportSection = SettingsSection(title: "SUPPORT",
                                             cells: [telegramChatSupportCell])
        
        mainView.settingsSections? = [appSettingsSection,
                                      appIconSection,
                                      supportSection]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorThemeSettingsCell.refresh()
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = colorThemeComponent.colorTheme.settingsScreen.backgroundColor
        let titleAttribute = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
        appearance.largeTitleTextAttributes = titleAttribute
        appearance.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.standardAppearance = appearance
    
        navigationController?.navigationBar.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
        
        unitsSettingsCell.reloadColorTheme()
        colorThemeSettingsCell.reloadColorTheme()
        mainView.reloadColorTheme()
        appIconSettingsCell.reloadColorTheme()
        telegramChatSupportCell.reloadColorTheme()
    }
}

extension SettingsViewController: UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int) {
        switch value {
        case 0:
            UserDefaultsManager.UnitData.set(with: K.UserDefaults.metric)
        case 1:
            UserDefaultsManager.UnitData.set(with: K.UserDefaults.imperial)
        default:
            break
        }
        
        mainMenuDelegate?.fetchWeatherData()
    }
}

extension SettingsViewController: ColorThemeSettingsCellDelegste {
    func presentColorThemes() {
        let colorThemeSettingsViewController = ColorThemeSettingsViewController(colorThemeComponent: colorThemeComponent)
        colorThemeSettingsViewController.colorThemeComponent = colorThemeComponent
        colorThemeSettingsViewController.reloadingViews.append(self)
        if let safeMainMenuDelegate = mainMenuDelegate {
            colorThemeSettingsViewController.reloadingViews.append(safeMainMenuDelegate)
        }
        navigationController?.pushViewController(colorThemeSettingsViewController, animated: true)
    }
}

extension SettingsViewController: AppIconSettingsCellDelegate {
    func getCurrentAppIconPosition() -> Int {
        return UserDefaultsManager.AppIcon.get()
    }
    
    func changeAppIcon(_ appIconModel: BMAppIcon) {
        UserDefaultsManager.AppIcon.set(with: appIconModel.rawValue)
        AppIconManager().setIcon(appIconModel)
    }
}

extension SettingsViewController: TelegramChatSupportDelegate {
    func moveToTelegramChat() {
        if let safeUrl = URL.init(string: "https://t.me/climaWeather"), UIApplication.shared.canOpenURL(safeUrl) {
            UIApplication.shared.open(safeUrl)
        } else if let urlAppStore = URL(string: "itms-apps://itunes.apple.com/app/id686449807"), UIApplication.shared.canOpenURL(urlAppStore)  {
            UIApplication.shared.open(urlAppStore)
        }
    }
}
