//
//  SettingsView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 23.09.2021.
//

import UIKit

class SettingsView: UIView {
    
    // MARK: - Properties
    
    weak var viewControllerOwner: SettingsViewController?
    var settingsSections: [SettingsSection]? = []
    
    // MARK: - Private properties

     private var tableView: UITableView = {
         let tableView = UITableView(frame: .zero, style: .insetGrouped)
         tableView.accessibilityIdentifier = "SettingsTableView"
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.backgroundColor = .clear
         return tableView
    }()
    
    private let colorTheme: ColorThemeProtocol
    
    // MARK: - Construction
    
    required init(colorTheme: ColorThemeProtocol) {
        self.colorTheme = colorTheme
        super.init(frame: .zero)
        
        backgroundColor = colorTheme.colorTheme.settingsScreen.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self

        addSubview(tableView)

        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions

    private func setUpConstraints() {
        // TableView
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections?[section].cells.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let safeCell = settingsSections?[indexPath.section].cells[indexPath.row] else {
            return UITableViewCell()
        }
        return safeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections?[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = settingsSections?[indexPath.section].cells[indexPath.row] as? SettingsCellTappableProtocol {
            cell.tapCell()
        }
    }
}
