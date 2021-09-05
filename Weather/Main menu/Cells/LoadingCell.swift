//
//  StandartTableViewCell.swift
//  Weather
//
//  Created by Александр on 20.05.2021.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var cityLoadView: UIView!
    @IBOutlet weak var timeLoadView: UIView!
    @IBOutlet weak var degreeLoadView: UIView!
    @IBOutlet weak var weatherBackgroundView: UIView!
    
    private let gradient = CAGradientLayer()
    private let cellShapeMask = UIView()
    
    // MARK: - Lifecycle
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        //Configuring gradient frame when views calculating
        gradient.frame = weatherBackgroundView.bounds
        
        DesignManager.setBackgroundStandartShape(layer: gradient)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Setting up gray lines corners
        cityLoadView.layer.cornerRadius = 5
        timeLoadView.layer.cornerRadius = 5
        degreeLoadView.layer.cornerRadius = 10
        
        //Setting up cell shape
        DesignManager.setBackgroundStandartShape(layer: weatherBackgroundView.layer)
        
        //Making shadow
        DesignManager.setBackgroundStandartShadow(layer: weatherBackgroundView.layer)
        
        //Making cells shadow be able to spill over other cells
        layer.masksToBounds = false
        backgroundColor = .clear
        
        //Setting up gradient layer
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        
        gradient.colors = DesignManager.getStandartGradientColor(withStyle: .blank)
        
        weatherBackgroundView.layer.insertSublayer(gradient, at: 0) //Adding gradient at the bottom
    }

}
