//
//  BackgroundDesignManager.swift
//  Weather
//
//  Created by Александр on 16.05.2021.
//

import UIKit

struct DesignManager {
    
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
}
