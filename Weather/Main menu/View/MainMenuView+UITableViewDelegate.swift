//
//  MainMenuView+UITableViewDelegate.swift
//  Weather
//
//  Created by Alexander Rubtsov on 08.09.2021.
//

import UIKit

extension MainMenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Hide welcome image if there is something to show
        //welcomeImage.isHidden = viewController?.displayWeather.count != 0 ? true : false
        return viewController?.displayWeather.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //If the data is loaded for cells
        if viewController?.displayWeather[indexPath.row] != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cityCellIdentifier) as! MainMenuTableViewCell
            
            let weatherDataForCell = viewController?.displayWeather[indexPath.row]
            
            // Populate the cell with data
            cell.cityNameLabel.text = viewController?.displayWeather[indexPath.row]?.cityName
            cell.degreeLabel.text = weatherDataForCell!.temperatureString
            
            //Setting up time label
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: weatherDataForCell!.timezone)
            dateFormatter.dateFormat = "hh:mm"
            cell.timeLabel.text = dateFormatter.string(from: date)
            
            let cellImageName = WeatherModel.getcConditionNameBy(conditionId: weatherDataForCell!.conditionId)
            
            //Reset the image only in case if it is needed for smooth animation
            if cell.conditionImage.image != UIImage(systemName: cellImageName) {
                cell.conditionImage.image = UIImage(systemName: cellImageName)?.withRenderingMode(.alwaysTemplate)
                cell.conditionImage.tintColor = .black // <-- remove later
            }
            
            //Setting up gradient background
            //...
            
            cell.layoutIfNeeded() // Eliminate layouts left from loading cells
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: K.cityLoadingCellIdentifier) as! LoadingCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.showDetailViewVC()
    }
    
    // Cell editing
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            
            //Deleting the data
            self.viewController?.displayWeather.remove(at: indexPath.row)
            CityDataFileManager.deleteCity(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: K.ImageName.deleteImage)
        deleteAction.backgroundColor = .white

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    // Cell highlight functions
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell {
            cell.isHighlighted = true
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell {
            cell.isHighlighted = false
        }
    }
}

// MARK: - tableView reorder functionality

extension MainMenuView: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let mover = viewController?.displayWeather.remove(at: sourceIndexPath.row)
        viewController?.displayWeather.insert(mover, at: destinationIndexPath.row)
        
        CityDataFileManager.rearrangeCity(atRow: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider:  NSItemProvider())
        dragItem.localObject = viewController?.displayWeather[indexPath.row]
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
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
        //Getting rid of system design
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        //param.shadowPath = UIBezierPath(rect: .zero)
        
        return param
    }
}
