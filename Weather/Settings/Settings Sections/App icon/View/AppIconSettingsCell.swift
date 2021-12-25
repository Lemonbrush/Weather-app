//
//  AppIconSettingsCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 14.11.2021.
//

import UIKit

protocol AppIconSettingsCellDelegate: AnyObject {
    func getCurrentAppIconPosition() -> Int
    func changeAppIcon(_ appIconModel: BMAppIcon)
}

class AppIconSettingsCell: UITableViewCell, ReloadColorThemeProtocol {
    
    // MARK: - Functions
    
    weak var delegate: AppIconSettingsCellDelegate?
    
    // MARK: - Private properties
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: Grid.pt72, height: Grid.pt72)
        layout.minimumLineSpacing = Grid.pt20
        layout.minimumInteritemSpacing = Grid.pt20
        layout.sectionInset = UIEdgeInsets(top: 0, left: Grid.pt20, bottom: 0, right: Grid.pt20)
        layout.shouldInvalidateLayout(forBoundsChange: CGRect())
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AppIconCollectionViewCell.self, forCellWithReuseIdentifier: K.CellIdentifier.appIconCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private var selectedCellNum: Int
    private var selectedCell: AppIconCollectionViewCell?
    
    private let colorThemeComponent: ColorThemeProtocol
    private let appIconsData: [BMAppIcon]

    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol,
         appIconsData: [BMAppIcon],
         chosenIconNum: Int) {
        self.colorThemeComponent = colorThemeComponent
        self.appIconsData = appIconsData
        self.selectedCellNum = chosenIconNum
        super.init(style: .default, reuseIdentifier: nil)
        
        selectionStyle = .none
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        
        collectionView.reloadData()
        setupConstraints()
        
        collectionView.scrollToItem(at: IndexPath(row: chosenIconNum, section: 0),
                                    at: [.centeredHorizontally], animated: false)
        
        reloadColorTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.cellsBackgroundColor
        collectionView.reloadData()
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        collectionView.heightAnchor.constraint(equalToConstant: Grid.pt112).isActive = true
    }
}

extension AppIconSettingsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appIconsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellIdentifier.appIconCell, for: indexPath) as? AppIconCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let settingsColors = colorThemeComponent.colorTheme.settingsScreen
        
        cell.selectedBorderColor = settingsColors.appIconSelectBorderColor.cgColor
        cell.deSelectedBorderColor = settingsColors.appIconDeselectBorderColor.cgColor
        
        cell.prepareForReuse()
        if indexPath.row == selectedCellNum {
            cell.selectCell(true)
            selectedCell = cell
        }
        
        cell.iconImage.image = appIconsData[indexPath.row].preview
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AppIconCollectionViewCell else {
            return
        }
        
        selectedCell?.selectCell(false)
        cell.selectCell(true)
        selectedCell = cell
        selectedCellNum = indexPath.row
        
        delegate?.changeAppIcon(appIconsData[indexPath.row])
    }
}
