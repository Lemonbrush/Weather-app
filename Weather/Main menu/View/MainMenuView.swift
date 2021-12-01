//
//  MainMenuView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 05.09.2021.
//

import UIKit

class MainMenuView: UIView {

    // MARK: - Private properties

    private var tableViewHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var currentDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "date label"
        return label
    }()

    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Today"
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "SettingsButton"
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "switch.2", withConfiguration: imageConfiguration), for: .normal)
        return button
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "SearchButton"
        button.addTarget(self, action: #selector(addNewCityButtonPressed), for: .touchUpInside)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: imageConfiguration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var mainHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()

    private var todayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private var refreshControl = UIRefreshControl()

    // MARK: - Public properties

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        // Space before the first cell
        tableView.contentInset.top = 10 // Getting rid of any delays between user touch and cell animation
        tableView.delaysContentTouches = false // Setting up drag and drop delegates
        tableView.dragInteractionEnabled = true
        tableView.register(LoadingCell.self, forCellReuseIdentifier: K.CellIdentifier.cityLoadingCell)
        tableView.register(MainMenuTableViewCell.self, forCellReuseIdentifier: K.CellIdentifier.cityCell)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear

        return tableView
    }()

    weak var viewController: MainMenuViewController?
    var colorThemeComponent: ColorThemeProtocol

    // MARK: - Construction

    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE d MMMM"
        let result = dateFormatter.string(from: currentDate).uppercased()
        currentDateLabel.text = result

        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        self.addSubview(tableView)

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        todayStackView.addArrangedSubview(todayLabel)
        todayStackView.addArrangedSubview(settingsButton)

        leftStackView.addArrangedSubview(currentDateLabel)
        leftStackView.addArrangedSubview(todayStackView)

        mainHeaderStackView.addArrangedSubview(leftStackView)
        mainHeaderStackView.addArrangedSubview(searchButton)

        tableViewHeaderView.addSubview(mainHeaderStackView)

        tableView.tableHeaderView = tableViewHeaderView

        reloadViews()
        setUpConstraints()
        tableView.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadViews() {
        searchButton.tintColor = colorThemeComponent.colorTheme.mainMenu.searchButtonColor
        settingsButton.tintColor = colorThemeComponent.colorTheme.mainMenu.settingsIconColor
        todayLabel.textColor = colorThemeComponent.colorTheme.mainMenu.todayColor
        currentDateLabel.textColor = colorThemeComponent.colorTheme.mainMenu.dateLabelColor
        backgroundColor = colorThemeComponent.colorTheme.mainMenu.backgroundColor
    }

    // MARK: - Private Fucnctions

    private func setUpConstraints() {
        // TableView
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        // TableView header
        tableViewHeaderView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        tableViewHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true

        // Main stackView
        mainHeaderStackView.leadingAnchor.constraint(equalTo: tableViewHeaderView.leadingAnchor,
                                                     constant: 15).isActive = true

        let mainHeaderStackViewConstaint = mainHeaderStackView.trailingAnchor.constraint(equalTo: tableViewHeaderView.trailingAnchor,
                                                                                         constant: -15)
        mainHeaderStackViewConstaint.priority = UILayoutPriority(999)
        mainHeaderStackViewConstaint.isActive = true

        mainHeaderStackView.bottomAnchor.constraint(equalTo: tableViewHeaderView.bottomAnchor,
                                                    constant: -5).isActive = true
        mainHeaderStackView.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor,
                                                 constant: 5).isActive = true

        // Search button
        searchButton.heightAnchor.constraint(equalTo: settingsButton.heightAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: settingsButton.widthAnchor).isActive = true
    }

    // MARK: - Actions

    @objc func refreshWeatherData(_ sender: AnyObject) {
        viewController?.fetchWeatherData()
        refreshControl.endRefreshing()
    }

    @objc func addNewCityButtonPressed() {
        viewController?.showAddCityVC()
    }

    @objc func settingsButtonPressed() {
        viewController?.showSettingsVC()
    }
}
