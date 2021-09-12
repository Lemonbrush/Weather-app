//
//  DailyForecastTableView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 11.09.2021.
//

import UIKit

class WeeklyForecastTableView: UIView {
    
    //MARK: - Public properties
    
    var dataSource: WeatherModel?
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(WeeklyForecastTableViewCell.self, forCellReuseIdentifier: K.weeklyCellIdentifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Private properties
    
    private var backgroundView: UIView = {
        let view = UIView()
        DesignManager.setBackgroundStandartShape(layer: view.layer)
        DesignManager.setBackgroundStandartShadow(layer: view.layer)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tableView.dataSource = self
        tableView.delegate = self
 
        addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        
        tableView.reloadData()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public functions
    
    func reloadData(_ newData: WeatherModel) {
        dataSource = newData
        tableView.reloadData()
    }
    
    //MARK: - Private functions
    
    private func setupConstraints() {
        //BackgroundView
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //TableView
        tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20).isActive = true
    }
}

extension WeeklyForecastTableView: UITableViewDataSource, UITableViewDelegate {
    
    // TODO: here should be weekly forecast
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataSource?.daily.count ?? 0)
        
        return dataSource?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.weeklyCellIdentifier) as! WeeklyForecastTableViewCell
        
        guard let safeWeatherData = dataSource else {
            return UITableViewCell()
        }
        
        let targetWeather = safeWeatherData.daily[indexPath.row]
        
        //Setting up date
        let date = Date(timeIntervalSince1970: TimeInterval(targetWeather.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: safeWeatherData.timezone)
        dateFormatter.dateFormat = "d EEEE"
        
        cell.monthLabel.text = dateFormatter.string(from: date)
        
        if indexPath.row == 0 {
            cell.monthLabel.text = "Today"
            cell.monthLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        
        cell.temperatureLabel.text = String(format: "%.0f°", targetWeather.temp.max)
        cell.minTemperatureLabel.text = String(format: "%.0f°", targetWeather.temp.min)
        
        let cellImageName = WeatherModel.getcConditionNameBy(conditionId: targetWeather.weather[0].id)
        cell.conditionImage.image = UIImage(systemName: cellImageName)?.withRenderingMode(.alwaysTemplate)
        cell.conditionImage.tintColor = .black
        
        return cell
    }
    
}
