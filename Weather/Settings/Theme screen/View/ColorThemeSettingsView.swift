//
//  ColorThemeSettingsView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ColorThemeSettingsView: UIView, ReloadColorThemeProtocol {
    
    // MARK: - Private properties
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.accessibilityIdentifier = "ColorSettingsTableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ColorThemeCell.self, forCellReuseIdentifier: "colorThemeCell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var chosenColorThemePosition = 0
    private var currentColorTheme: ColorThemeProtocol
    private var colorThemes: [ColorThemeModel]
    
    // MARK: - Public properties
    
    var viewControllerOwner: ColorThemeSettingsViewController?
    
    // MARK: - Construction
    
    init(currentColorTheme: ColorThemeProtocol ,colorThemes: [ColorThemeModel]) {
        self.currentColorTheme = currentColorTheme
        self.colorThemes = colorThemes
        
        super.init(frame: .zero)
        
        refreshCheckedColorTmeme()
        
        tableView.delegate = self
        tableView.dataSource = self

        addSubview(tableView)

        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = currentColorTheme.colorTheme.settingsScreen.backgroundColor
        tableView.reloadData()
    }
    
    // MARK: - Private functions

    private func setUpConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func refreshCheckedColorTmeme() {
        chosenColorThemePosition = UserDefaultsManager.ColorTheme.getCurrentColorThemeNumber()
        backgroundColor = currentColorTheme.colorTheme.settingsScreen.backgroundColor
        tableView.reloadData()
    }
}

extension ColorThemeSettingsView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorThemes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorThemeCell") as? ColorThemeCell else {
            return UITableViewCell()
        }
        
        let colorTheme = colorThemes[indexPath.row]
        cell.resetCell()
        cell.subtitle.text = colorTheme.title
        if chosenColorThemePosition == indexPath.row {
            cell.checkmarkImage.isHidden = false
        }
        
        cell.checkmarkImage.tintColor = colorTheme.settingsScreen.labelsColor
        cell.subtitle.textColor = colorTheme.settingsScreen.labelsSecondaryColor
        cell.colorBoxesView.setupBlocks(colorTheme.settingsScreen.colorBoxesColors)
        cell.backgroundColor = currentColorTheme.colorTheme.settingsScreen.cellsBackgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaultsManager.ColorTheme.setChosenPositionColorTheme(with: indexPath.row)
        refreshCheckedColorTmeme()
        viewControllerOwner?.refreshCurrentColorThemeSettingsCell(colorThemePosition: indexPath.row)
    }
}
