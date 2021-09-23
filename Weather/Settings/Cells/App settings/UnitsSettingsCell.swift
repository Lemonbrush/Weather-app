//
//  UnitsSettingsCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 23.09.2021.
//

import UIKit

protocol UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int)
}

class UnitsSettingsCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private var unitSwitch: UISegmentedControl = {
        let items = ["°C", "°F"]
        let switcher = UISegmentedControl(items: items)
        switcher.accessibilityIdentifier = "SettingsUnitSwitch"
        switcher.selectedSegmentIndex = 0
        switcher.backgroundColor = K.Colors.WeatherIcons.defaultColor
        switcher.addTarget(self, action: #selector(unitSwitchToggled), for: .valueChanged)
        return switcher
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Temperature"
        return label
    }()

    private var temperatureCellStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Public functions
    
    var delegate: UnitSwitchCellDelegate?
    
    // MARK: - Construction
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        switch UserDefaultsManager.getUnitData() {
        case K.UserDefaults.metric:
            unitSwitch.selectedSegmentIndex = 0
        case K.UserDefaults.imperial:
            unitSwitch.selectedSegmentIndex = 1
        default:
            unitSwitch.selectedSegmentIndex = 0
        }
        
        temperatureCellStackView.addArrangedSubview(temperatureLabel)
        temperatureCellStackView.addArrangedSubview(unitSwitch)

        contentView.addSubview(temperatureCellStackView)
        selectionStyle = .none
        
        unitSwitch.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        // TemperatureCell
        temperatureCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                      constant: 10).isActive = true
        temperatureCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: -10).isActive = true
        temperatureCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: 20).isActive = true
        temperatureCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -20).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func unitSwitchToggled() {
        delegate?.unitSwitchToggled(unitSwitch.selectedSegmentIndex)
    }
}
