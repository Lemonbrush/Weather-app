//
//  AddCityViewController.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import UIKit
import MapKit

struct Location {
    let latitude: Double
    let longitude: Double
}

class AddCityViewController: UIViewController {

    // MARK: - Properties

    var delegate: AddCityDelegate?
    
    var searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()

    // MARK: - Private properties
    
    private lazy var addCityView = AddCityView(colorThemeComponent: colorThemeComponent)
    private let colorThemeComponent: ColorThemeProtocol
    
    private var currentLocation = Location(latitude: 0, longitude: 0)
    private var isCurrentLocationUpdated = false
    private var shouldAddNewLocation = false

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.delegate = self
        searchCompleter.delegate = self
        
        locationManager.startUpdatingLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addCityView
        addCityView.delegate = self
    }
    
    // MARK: - Private functions
    
    private func didFinishedWithError(error: Error?) {
        delegate?.didFailAddingNewCityWithError(error: error)
    }
    
    private func addCity(title: String, lat: Double, long: Double) {
        delegate?.addNewItem(title, lat: lat, long: long)
        
        dismiss(animated: true) {
            self.delegate?.didAddNewCity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension AddCityViewController: AddCityViewDelegate {
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    func didChoseCity(title: String, subtitle: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = title + " " + subtitle

        MKLocalSearch(request: searchRequest).start { response, error in
            guard let response = response else {
                self.didFinishedWithError(error: error)
                return
            }

            // Save chosen city
            if let item = response.mapItems.first {
                let itemCoordinate = item.placemark.coordinate
                self.addCity(title: item.name ?? "---",
                             lat: itemCoordinate.latitude,
                             long: itemCoordinate.longitude)
            }
        }
    }
    
    func tryToAddCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        shouldAddNewLocation = true
        
        addCurrentLocationWeather()
    }
    
    func addCurrentLocationWeather() {
        guard isCurrentLocationUpdated else {
            return
        }
        
        shouldAddNewLocation = false
        
        let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            
            self.addCity(title: placemark.locality ?? "Your location",
                         lat: location.coordinate.latitude,
                         long: location.coordinate.longitude)
        }
    }
}

extension AddCityViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let searchResults = completer.results.filter { result in
            // Getting rid of any results that contain digits
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return false }
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return false }
            return true
        }
        
        addCityView.updateSearchResults(searchResults)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // TODO: handle completer error
        print(error.localizedDescription)
    }
}

extension AddCityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        currentLocation = Location(latitude: locationValue.latitude,
                                   longitude: locationValue.longitude)
        isCurrentLocationUpdated = true
        
        if shouldAddNewLocation {
            addCurrentLocationWeather()
        }
    }
}
