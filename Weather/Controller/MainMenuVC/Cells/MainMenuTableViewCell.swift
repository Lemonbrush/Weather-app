//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {
    
    //Cell styles
    enum GradientColors {
        case night, day, fog, blank
    }

    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherBackgroundView: UIView!
    
    private let gradient = CAGradientLayer()
    private let cellShapeMask = UIView()
    
    override var isHighlighted: Bool {
        didSet{
            //Animate this cell by highlight
            bounce(isHighlighted)
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        //Configuring gradient frame when views calculating
        gradient.frame = weatherBackgroundView.bounds
        
        DesignManager.setBackgroundStandartShape(layer: gradient)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
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
        
        setGradient(withStyle: .blank) //Set basic design
        
        weatherBackgroundView.layer.insertSublayer(gradient, at: 0) //Adding gradient at the bottom
    }
    
    // Helper functions
    func setGradient(withStyle style: GradientColors) {
        switch style {
        case .day: gradient.colors = [UIColor(red: 68/255, green: 166/255, blue: 252/255, alpha: 1).cgColor,
                                      UIColor(red: 114/255, green: 225/255, blue: 253/255, alpha: 1).cgColor]
        case .fog: break
        case .night: gradient.colors = [UIColor(red: 9/255, green: 7/255, blue: 40/255, alpha: 1).cgColor,
                                        UIColor(red: 30/255, green: 94/255, blue: 156/255, alpha: 1).cgColor]
        case .blank: gradient.colors = nil
        }
    }
    
    //MARK: - Cell animation by user interaction
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Cell bounce animation
    func bounce(_ bounce: Bool) {
        
        //Animation settings and allowing user to interact while the animation is running
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        
                        //Scale in and out
                        self.transform = bounce ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                        
                       }, completion: nil)
    }

}
