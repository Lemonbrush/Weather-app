//
//  TelegramChatSupportController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 27.11.2021.
//

import UIKit

class TelegramChatSupportCellController: TelegramChatSupportDelegate, ReloadColorThemeProtocol {

    // MARK: - Private
    
    let cell: TelegramChatSupportCell
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        cell = TelegramChatSupportCell(colorThemeComponent: colorThemeComponent)
        cell.delegate = self
    }
    
    // MARK: - Functions
    
    func moveToTelegramChat() {
        if let safeUrl = URL.init(string: "https://t.me/climaWeather"), UIApplication.shared.canOpenURL(safeUrl) {
            UIApplication.shared.open(safeUrl)
        } else if let urlAppStore = URL(string: "itms-apps://itunes.apple.com/app/id686449807"), UIApplication.shared.canOpenURL(urlAppStore)  {
            UIApplication.shared.open(urlAppStore)
        }
    }
    
    func reloadColorTheme() {
        cell.reloadColorTheme()
    }
}
