//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Александр on 20.06.2021.
//

import UIKit

class SettingsTableViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var unitSwitch: UISegmentedControl = {
        let items = ["°C", "°F"]
        let switcher = UISegmentedControl(items: items)
        switcher.selectedSegmentIndex = 0
        switcher.backgroundColor = .systemGreen
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
    
    private var temperatureCell = UITableViewCell()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Public properties
    
    var mainMenuDelegate: MainMenuDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        switch UserDefaultsManager.getUnitData() {
        case Unit.metric.rawValue:
            unitSwitch.selectedSegmentIndex = 0
        case Unit.imperial.rawValue:
            unitSwitch.selectedSegmentIndex = 1
        default:
            unitSwitch.selectedSegmentIndex = 0
        }
        
        temperatureCellStackView.addArrangedSubview(temperatureLabel)
        temperatureCellStackView.addArrangedSubview(unitSwitch)
        
        temperatureCell.contentView.addSubview(temperatureCellStackView)
        
        view.addSubview(tableView)
        
        setUpConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainMenuDelegate?.fetchWeatherData()
    }
    
    //MARK: - Private functions
    
    private func setUpConstraints() {
        
        //TableView
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //TemperatureCell
        temperatureCellStackView.topAnchor.constraint(equalTo: temperatureCell.contentView.topAnchor, constant: 10).isActive = true
        temperatureCellStackView.bottomAnchor.constraint(equalTo: temperatureCell.contentView.bottomAnchor, constant: -10).isActive = true
        temperatureCellStackView.leadingAnchor.constraint(equalTo: temperatureCell.contentView.leadingAnchor, constant: 20).isActive = true
        temperatureCellStackView.trailingAnchor.constraint(equalTo: temperatureCell.contentView.trailingAnchor, constant: -20).isActive = true
        
        unitSwitch.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    //MARK: - Actions
    
    @objc func unitSwitchToggled() {
        switch unitSwitch.selectedSegmentIndex {
        case 0:
            UserDefaultsManager.setUnitData(with: .metric)
        case 1:
            UserDefaultsManager.setUnitData(with: .imperial)
        default:
            break
        }
    }
}

extension SettingsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return temperatureCell
    }
}
