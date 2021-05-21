//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
        gradient.colors = DesignManager.getStandartGradientColor(withStyle: .blank)
        
        weatherBackgroundView.layer.insertSublayer(gradient, at: 0) //Adding gradient at the bottom
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
