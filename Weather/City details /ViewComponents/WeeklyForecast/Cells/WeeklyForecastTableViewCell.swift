//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Александр on 13.06.2021.
//

import UIKit

class WeeklyForecastTableViewCell: UITableViewCell {

    //MARK: - Public properties
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Private properties
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var degreeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Construxtion
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        degreeStackView.addArrangedSubview(temperatureLabel)
        degreeStackView.addArrangedSubview(minTemperatureLabel)
        
        mainStackView.addArrangedSubview(monthLabel)
        mainStackView.addArrangedSubview(degreeStackView)
        addSubview(mainStackView)
        addSubview(conditionImage)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private functions
    
    private func setupConstraints() {
        //Main stack
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        //Condition image
        //conditionImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        //conditionImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        conditionImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        conditionImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        //Degree stackView
        degreeStackView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        //MonthLabel
        monthLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 95).isActive = true
    }
}
