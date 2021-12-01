//
//  AddCityView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 09.09.2021.
//

import MapKit
import UIKit

protocol AddCityViewDelegate {
    var searchCompleter: MKLocalSearchCompleter { get }
    func dismissView()
    func didChoseCity(title: String, subtitle: String)
    func addCurrentLocationWeather()
}

class AddCityView: UIView {
    
    // MARK: - Properties

    var delegate: AddCityViewDelegate?

    // MARK: - Private properties

    private lazy var headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var searchBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = colorThemeComponent.colorTheme.addCityScreen.searchFieldBackground
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = CALayerCornerCurve.continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let shouldAddShadow = colorThemeComponent.colorTheme.addCityScreen.isShadowVisible
        if shouldAddShadow {
            DesignManager.setBackgroundStandartShadow(layer: view.layer)
        }
        return view
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.accessibilityIdentifier = "AddCityTextField"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.textColor = colorThemeComponent.colorTheme.addCityScreen.labelsColor
        textField.tintColor = colorThemeComponent.colorTheme.addCityScreen.labelsColor
        
        var placeHolder = NSAttributedString(string: "City",
                                             attributes: [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.addCityScreen.labelsColor])
        textField.attributedPlaceholder = placeHolder
        
        return textField
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "AddCityCancelButton"
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(colorThemeComponent.colorTheme.addCityScreen.cancelButtonColor, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "location.circle", withConfiguration: imageConfiguration), for: .normal)
        button.addTarget(self, action: #selector(currentLocationButtonPressed), for: .touchUpInside)
        button.tintColor = colorThemeComponent.colorTheme.addCityScreen.cancelButtonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var handleView: UIView = {
        let view = UIView()
        view.backgroundColor = colorThemeComponent.colorTheme.addCityScreen.handleColor
        view.layer.cornerRadius = 5 / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchFieldDivider: UIView = {
        let view = UIView()
        view.backgroundColor = colorThemeComponent.colorTheme.addCityScreen.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchFieldSpaceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var searchResults = [MKLocalSearchCompletion]()
    
    private let colorThemeComponent: ColorThemeProtocol

    // MARK: - Lifecycle

    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)

        backgroundColor = colorThemeComponent.colorTheme.addCityScreen.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubview(tableView)

        searchStackView.addArrangedSubview(currentLocationButton)
        searchStackView.addArrangedSubview(searchFieldDivider)
        searchStackView.addArrangedSubview(searchFieldSpaceView)
        searchStackView.addArrangedSubview(textField)
        
        mainStackView.addArrangedSubview(searchStackView)
        mainStackView.addArrangedSubview(cancelButton)

        addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(handleView)
        headerBackgroundView.addSubview(searchBackgroundView)
        searchBackgroundView.addSubview(mainStackView)
        
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        keyboardGesture.cancelsTouchesInView = false
        addGestureRecognizer(keyboardGesture)

        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func updateSearchResults(_ results: [MKLocalSearchCompletion]) {
        searchResults = results
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Private functions

    private func setUpConstraints() {
        // Header background view
        headerBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        // Handle
        handleView.widthAnchor.constraint(equalTo: headerBackgroundView.widthAnchor, multiplier: 0.3).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handleView.centerXAnchor.constraint(equalTo: headerBackgroundView.centerXAnchor).isActive = true
        handleView.topAnchor.constraint(equalTo: headerBackgroundView.topAnchor, constant: 10).isActive = true

        // Serach background
        searchBackgroundView.topAnchor.constraint(equalTo: headerBackgroundView.topAnchor, constant: 60).isActive = true
        searchBackgroundView.leadingAnchor.constraint(equalTo: headerBackgroundView.leadingAnchor, constant: 20).isActive = true
        searchBackgroundView.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -20).isActive = true
        searchBackgroundView.bottomAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: 0).isActive = true

        // Search stack
        mainStackView.topAnchor.constraint(equalTo: searchBackgroundView.topAnchor, constant: 5).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: searchBackgroundView.bottomAnchor,  constant: -5).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: searchBackgroundView.leadingAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: searchBackgroundView.trailingAnchor, constant: -20).isActive = true

        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        searchFieldSpaceView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        // TableView
        tableView.topAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // CurrentLocation button
        currentLocationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        currentLocationButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: searchFieldDivider.trailingAnchor, constant: 20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Divider
        searchFieldDivider.heightAnchor.constraint(equalToConstant: 35).isActive = true
        searchFieldDivider.widthAnchor.constraint(equalToConstant: 2).isActive = true
    }

    // MARK: - Actions
    
    @objc func currentLocationButtonPressed() {
        delegate?.addCurrentLocationWeather()
    }

    @objc func cancelButtonPressed() {
        delegate?.dismissView()
    }

    @objc func textFieldDidChange() {
        guard let query = textField.text, let safeDelegate = delegate else {
            return
        }
        safeDelegate.searchCompleter.queryFragment = query
        safeDelegate.searchCompleter.resultTypes = .address
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

extension AddCityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    
        cell.textLabel?.text = searchResult.title
        cell.textLabel?.textColor = colorThemeComponent.colorTheme.addCityScreen.labelsColor
        
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.detailTextLabel?.textColor = colorThemeComponent.colorTheme.addCityScreen.labelsSecondaryColor
        
        cell.backgroundColor = colorThemeComponent.colorTheme.addCityScreen.searchFieldBackground
        
        cell.contentView.backgroundColor = .none
        cell.accessibilityIdentifier = "AddCityCell"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = searchResults[indexPath.row]
        delegate?.didChoseCity(title: selectedCity.title,
                               subtitle: selectedCity.subtitle)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: -40)
                   UIView.animate(
                    withDuration: 0.2,
                    delay: 0.01 * Double(indexPath.row),
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.1,
                    options: [.curveEaseInOut],
                    animations: {
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    })
    }
}
