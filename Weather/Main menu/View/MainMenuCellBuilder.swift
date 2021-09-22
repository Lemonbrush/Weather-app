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
    func build(cityLabelByString: String) -> Self

    @discardableResult
    func build(degreeLabelByString: String) -> Self

    @discardableResult
    func build(timeLabelByTimeZone: TimeZone?) -> Self

    @discardableResult
    func build(imageByConditionName: String) -> Self

    @discardableResult
    func build(gradient: CGGradient) -> Self

    var content: MainMenuTableViewCell { get }
}

final class MainMenuCellBuilder {

    private var _content = MainMenuTableViewCell()

}

extension MainMenuCellBuilder: MainMenuCellBuilderProtocol {

    func erase() -> Self {
        _content = MainMenuTableViewCell()
        return self
    }

    func build(cityLabelByString cityNameString: String) -> Self {
        _content.cityNameLabel.text = cityNameString
        return self
    }

    func build(degreeLabelByString degreeString: String) -> Self {
        _content.degreeLabel.text = degreeString
        return self
    }

    func build(timeLabelByTimeZone timeLabelTimeZone: TimeZone?) -> Self {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeLabelTimeZone
        dateFormatter.dateFormat = "hh:mm"

        _content.timeLabel.text = dateFormatter.string(from: date)
        return self
    }

    func build(imageByConditionName imageName: String) -> Self {
        let imageBuilder = ConditionImageBuilder()
        let newImage = imageBuilder
            .erase(.defaultColors)
            .build(systemImageName: imageName)
            .buildColor()
            .content
        
        _content.conditionImage.image = newImage

        return self
    }

    func build(gradient: CGGradient) -> Self {
        // Setting up gradient background
        // ...
        return self
    }

    var content: MainMenuTableViewCell {
        _content
    }
}
