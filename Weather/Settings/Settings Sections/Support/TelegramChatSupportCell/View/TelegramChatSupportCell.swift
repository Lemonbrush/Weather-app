//
//  TelegramChatSupportCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 25.11.2021.
//

import UIKit

protocol TelegramChatSupportDelegate {
    func moveToTelegramChat()
}

class TelegramChatSupportCell: StandartSettingsCell, ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    var delegate: TelegramChatSupportDelegate?
    
    // MARK: - Private properties
    
    private let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(title: "Chat to telegram", systemImageName: K.SystemImageName.paperplane)
        
        reloadColorTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadColorTheme() {
        let settingsColors = colorThemeComponent.colorTheme.settingsScreen
        titleLabel.textColor = settingsColors.labelsSecondaryColor
        settingsIcon.tintColor = settingsColors.labelsSecondaryColor
        contentView.backgroundColor = settingsColors.cellsBackgroundColor
    }
}

extension TelegramChatSupportCell: SettingsCellTappableProtocol {
    func tapCell() {
        delegate?.moveToTelegramChat()
    }
}
