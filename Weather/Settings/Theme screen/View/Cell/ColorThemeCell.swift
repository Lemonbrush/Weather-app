//
//  ColorThemeSettingsCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 25.09.2021.
//

import UIKit

class ColorThemeCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - Public properties
    
    let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: K.SystemImageName.checkmark)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        
        return label
    }()
    
    let colorBoxesView = ThemeColorsBlocksView()
    
    // MARK: - Construction
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        leftStackView.addArrangedSubview(colorBoxesView)
        leftStackView.addArrangedSubview(subtitle)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(checkmarkImage)
        
        addSubview(mainStackView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Grid.pt20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Grid.pt16).isActive = true
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: Grid.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Grid.pt20).isActive = true
    }
    
    // MARK: - Public functions
    
    func resetCell() {
        checkmarkImage.isHidden = true
    }
}
