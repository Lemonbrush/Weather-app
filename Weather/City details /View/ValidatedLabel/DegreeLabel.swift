//
//  degreeLabel.swift
//  Weather
//
//  Created by Alexander Rubtsov on 11.11.2021.
//

import UIKit

class DegreeLabel: UILabel {
    override var text: String? {
        didSet {
            validateText()
        }
    }
    
    func validateText() {
        if let labelText = text, labelText.first != "-" && labelText.first != " " {
            text = " " + labelText
        }
    }
}
