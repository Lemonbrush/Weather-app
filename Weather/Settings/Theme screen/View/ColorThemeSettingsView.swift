//
//  ColorThemeSettingsView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ColorThemeSettingsView: UIView {
    
    // MARK: - Private properties
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.accessibilityIdentifier = "ColorSettingsTableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ColorThemeCell.self, forCellReuseIdentifier: "colorThemeCell")
        return tableView
    }()
    
    private var chosenColorThemePosition = 0
    
    // MARK: - Public properties
    
    var viewControllerOwner: ColorThemeSettingsViewController?
    var colorThemes: [ColorThemeModel]?
    
    // MARK: - Construction
    
    required init() {
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
    
    // MARK: - Private functions

    private func setUpConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func refreshCheckedColorTmeme() {
        if let newPosition = UserDefaultsManager.ColorTheme.getCurrentColorThemeNumber() {
            chosenColorThemePosition = newPosition
        }
        tableView.reloadData()
    }
}

extension ColorThemeSettingsView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorThemes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorThemeCell") as? ColorThemeCell,
              let colorTheme = colorThemes?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.resetCell()
        cell.subtitle.text = colorTheme.title
        if chosenColorThemePosition == indexPath.row {
            cell.checkmarkImage.isHidden = false
        }
        var colors: [UIColor] = []
        
        colors.append(colorTheme.clearSky.colors.first ?? .white)
        colors.append(colorTheme.fewClouds.colors.first ?? .white)
        colors.append(colorTheme.showerRain.colors.first ?? .white)
        colors.append(colorTheme.thunderstorm.colors.first ?? .white)
        colors.append(colorTheme.snow.colors.first ?? .white)
        
        cell.colorBoxesView.setupColors(colors)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaultsManager.ColorTheme.setChosenPositionColorTheme(with: indexPath.row)
        refreshCheckedColorTmeme()
        viewControllerOwner?.refreshCurrentColorThemeSettingsCell(colorThemePosition: indexPath.row)
    }
}
