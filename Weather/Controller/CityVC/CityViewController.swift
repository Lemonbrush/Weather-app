//
//  ViewController.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var welcomeImage: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    let fadeTransitionAnimator = FadeTransitionAnimator()
    
    var refreshControl = UIRefreshControl()
    
    var weatherManager = WeatherManager()
    var cityIDs = [String]() //Presaved queries
    var displayWeather: [WeatherModel] = [] //Fetched data for display in the tableview
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        //Setting up the date label
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        let result = dateFormatter.string(from: currentDate)
        currentDateLabel.text = result
        
        //Refresh control settings
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        cityTable.addSubview(refreshControl)
        
        //Space before the first cell
        cityTable.contentInset.top = 10
        //Getting rid of any delays between user touch and cell animation
        cityTable.delaysContentTouches = false
        
        //Setting up drag and drop delegates
        cityTable.dragDelegate = self
        cityTable.dropDelegate = self
        cityTable.dragInteractionEnabled = true
        
        weatherManager.delegate = self
        
        //Load saved city IDs and Fetch the data
        fetchWeatherData()
    }
    
    //Helper functions
    func fetchWeatherData() {
        cityIDs = CityDataFileManager.getSavedCities() ?? [String]()
        displayWeather.removeAll()
        weatherManager.fetchWeather(cityIDs: cityIDs)
    }
    
    // Hide and show welcome image depending on content
    func welcomeImageCheck() {
        if displayWeather.count != 0 {
            welcomeImage.isHidden = true
        } else {
            welcomeImage.isHidden = false
        }
    }
    
    //Pull-To-Refresh tableview
    @objc func refreshWeatherData(_ sender: AnyObject) {
        fetchWeatherData()
        refreshControl.endRefreshing()
    }
    
    //Transition to another viewcotroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addNewCity" {
            let destinationVC = segue.destination as! AddCityViewController
            destinationVC.cityVCReference = self
        }
    }

}

// MARK: - TableView

extension CityViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Hide welcome image if there is something to show
        welcomeImageCheck()
        
        return displayWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cityCellIdentifier) as! CityTableViewCell
        
        let weatherDataForCell = displayWeather[indexPath.row]
        
        // Populate the cell with data
        cell.cityNameLabel.text = weatherDataForCell.cityName
        cell.degreeLabel.text = weatherDataForCell.weatherTemperatureString
        
        //Setting up time label
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherDataForCell.timezone)
        dateFormatter.dateFormat = "hh:mm"
        cell.TimeLabel.text = dateFormatter.string(from: date)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.detailShowSegue, sender: self)
    }
    
    // Handle cell editing
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //Deleting the data
            displayWeather.remove(at: indexPath.row)
            cityIDs.remove(at: indexPath.row)
            CityDataFileManager.saveCities(cityIDs as NSArray)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /*
    // Customize cell editing buttons
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        <#code#>
    }
    */
    
    // Cell highlight functions
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell {
            cell.isHighlighted = true
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell {
            cell.isHighlighted = false
        }
    }
    
    // MARK: - tableView reorder functionality
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let mover = displayWeather.remove(at: sourceIndexPath.row)
        displayWeather.insert(mover, at: destinationIndexPath.row)
        
        CityDataFileManager.swapCities(atRow: sourceIndexPath.row, and: destinationIndexPath.row)
    }
    
    // Drag and drop functionality
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider:  NSItemProvider())
        dragItem.localObject = displayWeather[indexPath.row]
        
        return [dragItem]
    }
    
    // Setting up cell appearance while dragging and dropping
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        //Haptic effect
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
        
        return getDragAndDropCellAppearance(tableView ,forCellAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return getDragAndDropCellAppearance(tableView ,forCellAt: indexPath)
    }
    
    func getDragAndDropCellAppearance(_ tableView: UITableView, forCellAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell else {
            return nil
        }
        
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        param.visiblePath = UIBezierPath(roundedRect: cell.weatherBackgroundView.frame, cornerRadius: cell.weatherBackgroundView.layer.cornerRadius)
        param.shadowPath = UIBezierPath(rect: .zero)
        
        return param
    }
}

// MARK: - Fetching data Weather manager

extension CityViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel]) {
        
        DispatchQueue.main.async {
            self.displayWeather = weather
            self.cityTable.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        fatalError("Failed with - \(error)")
        //TODO: handle network disconection
    }
    
}

// MARK: - Transition animation

extension CityViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return fadeTransitionAnimator
    }
}
