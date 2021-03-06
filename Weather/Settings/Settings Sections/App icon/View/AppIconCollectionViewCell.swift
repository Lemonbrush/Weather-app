//
//  AppIconCollectionViewCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 14.11.2021.
//

import UIKit

class AppIconCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.pt16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var selectedBorderColor: CGColor = UIColor.black.cgColor
    var deSelectedBorderColor: CGColor = UIColor.lightGray.cgColor
    
    // MARK: - Constructions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImage)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func selectCell(_ select: Bool) {
        iconImage.layer.borderColor = select ? selectedBorderColor : deSelectedBorderColor
        iconImage.layer.borderWidth = select ? 3 : 2
    }
    
    override func prepareForReuse() {
        selectCell(false)
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        iconImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        iconImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        iconImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        iconImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        let iconImageSize: CGFloat = Grid.pt72
        iconImage.heightAnchor.constraint(equalToConstant: iconImageSize).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: iconImageSize).isActive = true
    }
}
