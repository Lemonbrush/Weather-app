//
//  BackgroundDesignManager.swift
//  Weather
//
//  Created by Александр on 16.05.2021.
//

import UIKit

struct DesignManager {
    
    //Cell styles
    enum GradientColors {
        case night, day, fog, blank
    }
    
    //Making proper round corners
    static func setBackgroundStandartShape(layer: CALayer) {
        layer.cornerCurve = CALayerCornerCurve.continuous
        layer.cornerRadius = 20
    }
    
    //Making shadow
    static func setBackgroundStandartShadow(layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 7
    }
    
    //Gradient
    static func getStandartGradientColor(withStyle style: GradientColors) -> [CGColor] {
        switch style {
        case .day: return [UIColor(red: 68/255, green: 166/255, blue: 252/255, alpha: 1).cgColor,
                                      UIColor(red: 114/255, green: 225/255, blue: 253/255, alpha: 1).cgColor]
        case .fog: return [UIColor.clear.cgColor]
        case .night: return [UIColor(red: 9/255, green: 7/255, blue: 40/255, alpha: 1).cgColor,
                                        UIColor(red: 30/255, green: 94/255, blue: 156/255, alpha: 1).cgColor]
        case .blank: return [UIColor.clear.cgColor]
        }
    }
    
    //Country id to country emoji flag converter
    static func countryFlag(byCode code: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
