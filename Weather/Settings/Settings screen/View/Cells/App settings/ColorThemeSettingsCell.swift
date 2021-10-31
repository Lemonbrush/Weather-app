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

class ColorThemeSettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    var colorThemeComponent: ColorThemeProtocol
    var delegate: ColorThemeSettingsCellDelegste?
    
    // MARK: - Private properties
    
    private lazy var themeIcon: UIImageView = {
        let imageView = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "paintbrush", withConfiguration: imageConfiguration) ?? UIImage()
        imageView.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var themeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Theme"
        label.textColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
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
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - Constructions
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(style: .default, reuseIdentifier: nil)
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.cellsBackgroundColor
        
        refresh()
        
        leftStackView.addArrangedSubview(themeIcon)
        leftStackView.addArrangedSubview(themeLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(themeColorBlocksView)
        
        contentView.addSubview(mainStackView)
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                      constant: 10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: -10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -20).isActive = true
    }
    
    func refresh() {
        themeColorBlocksView.setupBlocks(colorThemeComponent.colorTheme.settingsScreen.colorBoxesColors)
    }
}

extension ColorThemeSettingsCell: SettingsCellTappableProtocol {
    func tapCell() {
        delegate?.presentColorThemes()
    }
}
