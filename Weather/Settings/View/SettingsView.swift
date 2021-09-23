//
//  SettingsView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 23.09.2021.
//

import UIKit

class SettingsView: UIView {
    
    // MARK: - Private properties

     var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.accessibilityIdentifier = "SettingsTableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public properties
    
    weak var viewControllerOwner: SettingsViewController?
    var settingCells: [UITableViewCell]? = []
    
    // MARK: - Construction
    
    required init() {
        super.init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self

        addSubview(tableView)

        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions

    private func setUpConstraints() {
        // TableView
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingCells?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return settingCells?[indexPath.row] ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
