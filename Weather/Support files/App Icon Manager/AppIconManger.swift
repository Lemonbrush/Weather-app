//
//  AppIconManger.swift
//  Weather
//
//  Created by Alexander Rubtsov on 18.11.2021.
//

import Foundation
import UIKit

enum BMAppIcon: Int, CaseIterable {
    case classic,
    darkWhiteCloudAppIcon,
    whiteSunAppIcon
    
    var name: String? {
        switch self {
        case .classic:
            return nil
        case .darkWhiteCloudAppIcon:
            return "cloudNight"
        case .whiteSunAppIcon:
            return "sunSet"
        }
    }
    
    var preview: UIImage? {
        switch self {
        case .classic:
            return UIImage(named: "AppIcon")
        case .darkWhiteCloudAppIcon:
            return UIImage(named: "darkWhiteCloudAppIcon@3x.png")
        case .whiteSunAppIcon:
            return UIImage(named: "whiteSunAppIcon@3x.png")
        }
    }
}

class AppIconManager {
    var current: BMAppIcon {
        return BMAppIcon.allCases.first(where: {
            $0.name == UIApplication.shared.alternateIconName
        }) ?? .classic
        
    }
    
    func setIcon(_ appIcon: BMAppIcon, completion: ((Bool) -> Void)? = nil) {
        guard current != appIcon, UIApplication.shared.supportsAlternateIcons else {
            print(appIcon, UIApplication.shared.supportsAlternateIcons)
            return
        }

        UIApplication.shared.setAlternateIconName(appIcon.name) { error in
            if let error = error {
                print("Error setting alternative app icon \(appIcon.name ?? "???"): \(error.localizedDescription)")
            }
            
            completion?(error != nil)
        }
    }
}
