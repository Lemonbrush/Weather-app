//
//  EmailMeSupportCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 26.11.2021.
//

import UIKit
import MessageUI

typealias EmailMeAndMailComposeSupportCellDelegate = EmailMeSupportCellDelegate & MFMailComposeViewControllerDelegate

protocol EmailMeSupportCellDelegate {
    func triggerEmailForm()
}

class EmailMeSupportCell: StandartSettingsCell, ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    var delegate: EmailMeSupportCellDelegate?
    
    // MARK: - Private properties
    
    private let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(title: "Write to the author", systemImageName: "envelope")
        
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

extension EmailMeSupportCell: SettingsCellTappableProtocol {
    func tapCell() {
        delegate?.triggerEmailForm()
    }
}
