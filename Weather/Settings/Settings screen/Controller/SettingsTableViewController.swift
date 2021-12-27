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

protocol SettingsViewControllerDelegate: UIViewController {
    func refreshMainMenu()
}

class SettingsViewController: UIViewController, ReloadColorThemeProtocol {
    
    // MARK: - Private properties
    
    private lazy var appIconSettingsCellController = AppIconSettingsCellController(colorThemeComponent: colorThemeComponent)
    private lazy var telegramChatSupportCellController = TelegramChatSupportCellController(colorThemeComponent: colorThemeComponent)
    private lazy var emailMeSupportCellController: EmailMeSupportCellController = {
        let controller = EmailMeSupportCellController(colorThemeComponent: colorThemeComponent)
        controller.viewControllerOwner = self
        return controller
    }()
    private lazy var colorThemeSettingsCellController: ColorThemeSettingsCellController = {
        let controller = ColorThemeSettingsCellController(colorThemeComponent: colorThemeComponent)
        controller.viewControllerOwner = self
        controller.reloadingViews.append(mainView)
        return controller
    }()
    private lazy var unitsSettingsCellController: UnitsSettingsCellController = {
        let controller = UnitsSettingsCellController(colorThemeComponent: colorThemeComponent)
        controller.viewControllerOwner = self
        return controller
    }()
    
    private lazy var settingsCellsControllers: [ReloadColorThemeProtocol] = [appIconSettingsCellController,
                                                                             telegramChatSupportCellController,
                                                                             emailMeSupportCellController,
                                                                             colorThemeSettingsCellController,
                                                                             unitsSettingsCellController]
    
    private lazy var mainView = SettingsView(colorTheme: colorThemeComponent)

    // MARK: - Public properties

    weak var mainMenuDelegate: MainMenuDelegate?
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appSettingsSection = SettingsSection(title: "APP",
                                                 cells: [unitsSettingsCellController.cell,
                                                         colorThemeSettingsCellController.cell])
        
        let appIconSection = SettingsSection(title: "APP ICON",
                                             cells: [appIconSettingsCellController.cell])
        
        let supportSection = SettingsSection(title: "SUPPORT",
                                             cells: [telegramChatSupportCellController.cell,
                                                     emailMeSupportCellController.cell])
        
        mainView.settingsSections? = [appSettingsSection,
                                      appIconSection,
                                      supportSection]
        
        reloadColorTheme()
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        reloadAppearance()
        
        for reloadView in settingsCellsControllers {
            reloadView.reloadColorTheme()
        }
        
        mainView.reloadColorTheme()
        mainMenuDelegate?.reloadColorTheme()
    }
    
    // MARK: - Private functions
    
    private func reloadAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = colorThemeComponent.colorTheme.settingsScreen.backgroundColor
        let titleAttribute = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
        appearance.largeTitleTextAttributes = titleAttribute
        appearance.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
    }
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func refreshMainMenu() {
        mainMenuDelegate?.fetchWeatherData()
    }
}
