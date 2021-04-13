//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherBackgroundView: UIView!
    
    override var isHighlighted: Bool {
        didSet{
            //Animate this cell by highlight
            bounce(isHighlighted)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        //Making proper round corners
        weatherBackgroundView.layer.cornerCurve = CALayerCornerCurve.continuous
        weatherBackgroundView.layer.cornerRadius = 15
        
        //Making shadow
        weatherBackgroundView.layer.shadowColor = UIColor.black.cgColor
        weatherBackgroundView.layer.shadowOpacity = 0.07
        weatherBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }

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
