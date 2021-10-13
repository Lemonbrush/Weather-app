//
//  ConditionImageBuilder.swift
//  Weather
//
//  Created by Alexander Rubtsov on 22.09.2021.
//

import UIKit

enum ConditionColorMode {
    case onlyWhite
    case onlyBlack
    case defaultColors
}

protocol ConditionImageBuilderProtocol: AnyObject {
    
    @discardableResult
    func erase(_ customeColorMode: ConditionColorMode?) -> Self
    
    @discardableResult
    func build(systemImageName imageName: String) -> Self
    
    @discardableResult
    func buildColor(_ color: UIColor) -> Self
    
    var content: UIImage { get }
    var colorConfigurator: ConditionImageColorConfiguratorProtocol { get set }
}

final class ConditionImageBuilder {
    private var _content = UIImage()
    internal var colorConfigurator: ConditionImageColorConfiguratorProtocol = StandartConditionImageColorConfigurator()
}

extension ConditionImageBuilder: ConditionImageBuilderProtocol {
    
    func erase(_ customeColorMode: ConditionColorMode? = nil) -> Self {
        switch customeColorMode {
        case .onlyWhite:
            colorConfigurator = WhiteConditionImageColorConfigurator()
        case .onlyBlack:
            colorConfigurator = BlackConditionImageColorConfigurator()
        case .defaultColors, .none:
            colorConfigurator = StandartConditionImageColorConfigurator()
        }
        
        _content = UIImage()
        return self
    }
    
    func build(systemImageName imageName: String) -> Self {
        if let safeImageName = UIImage(systemName: imageName) {
            _content = safeImageName.withRenderingMode(.alwaysOriginal)
        }
        return self
    }
    
    func buildColor(_ color: UIColor) -> Self {
        _content = _content.withTintColor(color)
        return self
    }
    
    var content: UIImage {
        _content
    }
}