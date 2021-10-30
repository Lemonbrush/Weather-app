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
    
    // MARK: - Public functions
    
    var delegate: UnitSwitchCellDelegate?
    
    // MARK: - Private properties
    
    private lazy var unitSwitch: UISegmentedControl = {
        let items = ["°C", "°F"]
        let switcher = UISegmentedControl(items: items)
        switcher.accessibilityIdentifier = "SettingsUnitSwitch"
        switcher.selectedSegmentIndex = 0
        switcher.backgroundColor = colorThemeComponent.colorTheme.settingsScreen.temperatureSwitchColor
        switcher.addTarget(self, action: #selector(unitSwitchToggled), for: .valueChanged)
        return switcher
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Temperature"
        label.textColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        return label
    }()
    
    private lazy var settingsIcon: UIImageView = {
        let imageView = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "ruler", withConfiguration: imageConfiguration) ?? UIImage()
        imageView.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var temperatureCellStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        return stack
    }()
    
    private let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(style: .default, reuseIdentifier: nil)
        
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.cellsBackgroundColor
        
        switch UserDefaultsManager.getUnitData() {
        case K.UserDefaults.metric:
            unitSwitch.selectedSegmentIndex = 0
        case K.UserDefaults.imperial:
            unitSwitch.selectedSegmentIndex = 1
        default:
            unitSwitch.selectedSegmentIndex = 0
        }
        
        leftStackView.addArrangedSubview(settingsIcon)
        leftStackView.addArrangedSubview(temperatureLabel)
        
        temperatureCellStackView.addArrangedSubview(leftStackView)
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
