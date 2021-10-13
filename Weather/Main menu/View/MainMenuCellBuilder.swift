//
//  MainMenuCellBuilder.swift
//  Weather
//
//  Created by Alexander Rubtsov on 12.09.2021.
//

import UIKit

protocol MainMenuCellBuilderProtocol: AnyObject {

    // You should call it first
    @discardableResult
    func erase() -> Self
    
    @discardableResult
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int) -> Self

    @discardableResult
    func build(cityLabelByString: String) -> Self

    @discardableResult
    func build(degreeLabelByString: String) -> Self

    @discardableResult
    func build(timeLabelByTimeZone: TimeZone?) -> Self

    @discardableResult
    func build(imageByConditionId conditionId: Int, colorThemeModel: ColorThemeModel?) -> Self

    @discardableResult
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int, isDay: Bool)-> Self

    var content: MainMenuTableViewCell { get }
}

final class MainMenuCellBuilder {

    private var _content = MainMenuTableViewCell()
    private var colorTheme: ColorThemeModel?
    private var conditionId: Int?
}

extension MainMenuCellBuilder: MainMenuCellBuilderProtocol {

    func erase() -> Self {
        _content = MainMenuTableViewCell()
        return self
    }
    
    func build(colorThemeModel: ColorThemeModel?, conditionId: Int) -> Self {
        self.colorTheme = colorThemeModel
        self.conditionId = conditionId
        return self
    }

    func build(cityLabelByString cityNameString: String) -> Self {
        _content.cityNameLabel.text = cityNameString
        _content.cityNameLabel.textColor = colorTheme?.getColorByConditionId(conditionId!).labelsColor
        return self
    }

    func build(degreeLabelByString degreeString: String) -> Self {
        _content.degreeLabel.text = degreeString
        _content.degreeLabel.textColor = colorTheme?.getColorByConditionId(conditionId!).labelsColor
        return self
    }

    func build(timeLabelByTimeZone timeLabelTimeZone: TimeZone?) -> Self {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeLabelTimeZone
        dateFormatter.dateFormat = "hh:mm"

        _content.timeLabel.text = dateFormatter.string(from: date)
        _content.timeLabel.textColor = colorTheme?.getColorByConditionId(conditionId!).labelsColor
        return self
    }

    func build(imageByConditionId conditionId: Int, colorThemeModel: ColorThemeModel?) -> Self {
        let imageBuilder = ConditionImageBuilder()
        let imageColor = colorThemeModel?.getColorByConditionId(conditionId).iconsColor ?? .black
        let newImage = imageBuilder
            .erase(.defaultColors)
            .build(systemImageName: WeatherModel.getConditionNameBy(conditionId: conditionId))
            .buildColor(imageColor)
            .content
        
        _content.conditionImage.image = newImage

        return self
    }

    func build(colorThemeModel: ColorThemeModel?, conditionId: Int, isDay: Bool) -> Self {
        guard let safeColorThemeModel = colorThemeModel else {
            return self
        }
        let imageColor = colorThemeModel?.getColorByConditionId(conditionId).colors.first ?? .white
        
        _content.weatherBackgroundView.backgroundColor = imageColor
        return self
    }

    var content: MainMenuTableViewCell {
        _content
    }
}
