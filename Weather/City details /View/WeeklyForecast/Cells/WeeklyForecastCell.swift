//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Александр on 13.06.2021.
//

import UIKit

class WeeklyForecastCell: UITableViewCell {

    // MARK: - Public properties

    var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        return label
    }()

    var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        label.textColor = .gray
        return label
    }()

    var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Private properties

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
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Construxtion

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
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
    
    // MARK: - Functions
    
    func setupColorTheme(_ colorTheme: ColorThemeProtocol) {
        let weeklyColors = colorTheme.colorTheme.cityDetails.weeklyForecast
        monthLabel.textColor = weeklyColors.labelsColor
        temperatureLabel.textColor = weeklyColors.labelsColor
        minTemperatureLabel.textColor = weeklyColors.labelsSecondaryColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        monthLabel.font = UIFont.systemFont(ofSize: Grid.pt16, weight: .regular)
        monthLabel.textColor = .black
        temperatureLabel.textColor = .black
        minTemperatureLabel.textColor = .black
    }

    // MARK: - Private functions

    private func setupConstraints() {
        // Main stack
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Grid.pt12).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Grid.pt12).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Grid.pt12).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Grid.pt12).isActive = true

        // Condition image
        conditionImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        conditionImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        // Degree stackView
        degreeStackView.widthAnchor.constraint(equalToConstant: Grid.pt84).isActive = true

        // MonthLabel
        monthLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Grid.pt96).isActive = true
    }
}
