//
//  ThemeSettingsCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import Foundation
import UIKit

protocol ColorThemeSettingsCellDelegste {
    func presentColorThemes()
}

class ColorThemeSettingsCell: UITableViewCell, ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    var colorThemeComponent: ColorThemeProtocol
    var delegate: ColorThemeSettingsCellDelegste?
    
    // MARK: - Private properties
    
    private lazy var themeIcon: UIImageView = {
        let imageView = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "paintbrush", withConfiguration: imageConfiguration) ?? UIImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var themeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        label.text = "Theme"
        return label
    }()
    
    private let themeColorBlocksView = ThemeColorsBlocksView()
    
    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Grid.pt12
        return stack
    }()
    
    // MARK: - Constructions
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(style: .default, reuseIdentifier: nil)
        
        refresh()
        
        leftStackView.addArrangedSubview(themeIcon)
        leftStackView.addArrangedSubview(themeLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(themeColorBlocksView)
        
        contentView.addSubview(mainStackView)
        selectionStyle = .none
        
        reloadColorTheme()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.cellsBackgroundColor
        themeIcon.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        themeLabel.textColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
    }
    
    func refresh() {
        themeColorBlocksView.setupBlocks(colorThemeComponent.colorTheme.settingsScreen.colorBoxesColors)
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                      constant: Grid.pt20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: -Grid.pt20).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: Grid.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -Grid.pt20).isActive = true
    }
}

extension ColorThemeSettingsCell: SettingsCellTappableProtocol {
    func tapCell() {
        delegate?.presentColorThemes()
    }
}
