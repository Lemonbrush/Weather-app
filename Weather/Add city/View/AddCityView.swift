//
//  AddCityView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 09.09.2021.
//

import MapKit
import UIKit

class AddCityView: UIView {

    //MARK: - Private properties
    
    private var headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var searchBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = CALayerCornerCurve.continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City"
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray3, for: .highlighted)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.cornerRadius = 5/2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    //private var welcomeImage: UIImageView!
    
    //MARK: - Public properties
    
    var viewControllerOwner: AddCityViewController?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchCompleter.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        searchStackView.addArrangedSubview(textField)
        searchStackView.addArrangedSubview(cancelButton)
        
        addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(handleView)
        headerBackgroundView.addSubview(searchBackgroundView)
        searchBackgroundView.addSubview(searchStackView)
        addSubview(tableView)
        
        DesignManager.setBackgroundStandartShadow(layer: searchBackgroundView.layer)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private functions
    
    private func setUpConstraints() {
        
        //Header background view
        headerBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //Handle
        handleView.widthAnchor.constraint(equalTo: headerBackgroundView.widthAnchor, multiplier: 0.3).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handleView.centerXAnchor.constraint(equalTo: headerBackgroundView.centerXAnchor).isActive = true
        handleView.topAnchor.constraint(equalTo: headerBackgroundView.topAnchor, constant: 10).isActive = true
        
        //Serach background
        searchBackgroundView.topAnchor.constraint(equalTo: headerBackgroundView.topAnchor, constant: 60).isActive = true
        searchBackgroundView.leadingAnchor.constraint(equalTo: headerBackgroundView.leadingAnchor, constant: 20).isActive = true
        searchBackgroundView.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -20).isActive = true
        searchBackgroundView.bottomAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -15).isActive = true
        
        //Search stack
        searchStackView.topAnchor.constraint(equalTo: searchBackgroundView.topAnchor, constant: 5).isActive = true
        searchStackView.bottomAnchor.constraint(equalTo: searchBackgroundView.bottomAnchor, constant: -5).isActive = true
        searchStackView.leadingAnchor.constraint(equalTo: searchBackgroundView.leadingAnchor, constant: 20).isActive = true
        searchStackView.trailingAnchor.constraint(equalTo: searchBackgroundView.trailingAnchor, constant: -20).isActive = true
        
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //TableView
        tableView.topAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonPressed() {
        viewControllerOwner?.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        
        //change searchCompleter depends on searchBar's text
        guard let query = textField.text else { return }
        
        searchCompleter.queryFragment = query
        searchCompleter.resultTypes = .address
    }
}

extension AddCityView: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //get result, transform it to our needs and fill the dataSource
        self.searchResults = completer.results
        self.searchResults = completer.results.filter { result in
            //Getting rid of any results that contain digits
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return false }
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return false }
            return true
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //TODO: handle completer error
        print(error.localizedDescription)
    }
}

extension AddCityView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Hide welcome image if there is something to show
        //welcomeImage.isHidden = searchResults.count != 0 ? true : false
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.detailTextLabel?.textColor = .darkGray
        cell.contentView.backgroundColor = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = result.title + " " + result.subtitle

        MKLocalSearch(request: searchRequest).start { response, error in
            guard let response = response else {
                self.viewControllerOwner?.didFinishedWithError(error: error)
                return
            }
            
            //Save chosen city
            if let item = response.mapItems.first  {
                let itemCoordinate = item.placemark.coordinate
                self.viewControllerOwner?.didChoseCity(item.name ?? "---", lat: itemCoordinate.latitude, long: itemCoordinate.longitude)
            }
        }
    }
}
