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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
