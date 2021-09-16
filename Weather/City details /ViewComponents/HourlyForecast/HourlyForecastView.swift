//
//  HourlyForecast.swift
//  Weather
//
//  Created by Alexander Rubtsov on 11.09.2021.
//

import UIKit

class HourlyForecastView: UIView {
    
    //MARK: - Public properties
    
    var dataSource: WeatherModel?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.shouldInvalidateLayout(forBoundsChange: CGRect.init())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: K.CellIdentifier.hourlyForecastCell)
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HourlyForecastView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.hourlyDisplayData.count ?? 0
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellIdentifier.hourlyForecastCell, for: indexPath) as! HourlyCollectionViewCell
        //cell.image.tintColor = .black // <-- remove later
        
        guard let safeWeatherData = dataSource else {
            return UICollectionViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: safeWeatherData.timezone)
        
        let targetHourlyForecast = safeWeatherData.hourlyDisplayData[indexPath.row]
        
        switch targetHourlyForecast {
        case .weatherType(let currentHour):
            let date = Date(timeIntervalSince1970: TimeInterval(currentHour.dt))
            dateFormatter.dateFormat = "h a"
            
            cell.topLabel.text = indexPath.row == 0 ? "Now" : dateFormatter.string(from: date)
            let cellImageName = WeatherModel.getConditionNameBy(conditionId: currentHour.weather[0].id)
            cell.imageView.image = UIImage(systemName: cellImageName)
            cell.bottomLabel.text = String(format: "%.0f°", currentHour.temp)
            
            return cell
            
        case .sunState(let sunStete):
            //Setting up time
            let date = Date(timeIntervalSince1970: TimeInterval(sunStete.dt))
            dateFormatter.dateFormat = "h:mm a"
            
            cell.topLabel.text = dateFormatter.string(from: date)
            cell.imageView.image = UIImage(named: K.ImageName.defaultImage)
            cell.bottomLabel.text = sunStete.description == .sunrise ? "Sunrise" : "Sunset"
            
            return cell
        }
    }
    
    //Space insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
