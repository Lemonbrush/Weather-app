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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

        // Configure the view for the selected state
    }

}
