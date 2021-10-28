//
//  AddCityViewController.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import UIKit
import MapKit

class AddCityViewController: UIViewController {

    // MARK: - Properties

    var delegate: AddCityDelegate?

    // MARK: - Private properties
    
    private lazy var addCityView = AddCityView(colorThemeComponent: colorThemeComponent)
    private let colorThemeComponent: ColorThemeProtocol

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addCityView
        addCityView.viewControllerOwner = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Functions

    func didChoseCity(_ name: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        delegate?.addNewItem(name, lat: lat, long: long)

        dismiss(animated: true) {
            self.delegate?.didAddNewCity()
        }
    }

    func didFinishedWithError(error: Error?) {
        delegate?.didFailAddingNewCityWithError(error: error)
    }
}
