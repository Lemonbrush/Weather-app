//
//  ThemeColorsBlocksView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ThemeColorsBlocksView: UIView {
    
    // MARK: - Private properties
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Grid.pt4
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Construction
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(stackView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func makeColorBlock(color: UIColor) -> UIView {
        let blockSize: CGFloat = Grid.pt20
        let block = UIView()
        block.backgroundColor = color
        block.layer.cornerRadius = Grid.pt4
        block.translatesAutoresizingMaskIntoConstraints = false
       
        block.layer.shadowColor = UIColor.black.cgColor
        block.layer.shadowOpacity = 0.1
        block.layer.shadowOffset = CGSize(width: 0, height: Grid.pt4)
        block.layer.shadowRadius = Grid.pt8
        
        block.heightAnchor.constraint(equalToConstant: blockSize).isActive = true
        block.widthAnchor.constraint(equalToConstant: blockSize).isActive = true
        
        return block
    }
    
    // MARK: - Public functions
    
    func setupBlocks(_ colors: [UIColor]) {
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for color in colors {
            let block = makeColorBlock(color: color)
            stackView.addArrangedSubview(block)
        }
    }
}
