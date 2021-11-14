//
//  AppIconSettingsCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 14.11.2021.
//

import UIKit

class AppIconSettingsCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 70, height: 70)
        layout.shouldInvalidateLayout(forBoundsChange: CGRect())
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AppIconCollectionViewCell.self, forCellWithReuseIdentifier: "AppIconCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let colorThemeComponent: ColorThemeProtocol
    private let appIconsData: [UIImage]

    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol, appIconsData: [UIImage]) {
        self.colorThemeComponent = colorThemeComponent
        self.appIconsData = appIconsData
        super.init(style: .default, reuseIdentifier: nil)
        
        selectionStyle = .none
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        
        collectionView.reloadData()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        collectionView.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
}

extension AppIconSettingsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appIconsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppIconCell", for: indexPath) as? AppIconCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        
        cell.iconImage.image = appIconsData[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AppIconCollectionViewCell else {
            return
        }
        cell.selectCell(true)
    }
    
    // Space insets
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
