//
//  ThemeColorsBlocksView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ThemeColorsBlocksView: UIView {
    
    // MARK: - Private functions
    
    private let numberOfBlocks = 5
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var blocks: [UIView] = []
    
    // MARK: - Construction
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(stackView)
        
        setupConstraints()
        setupBlocks()
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
    
    private func setupBlocks() {
        for _ in 0...numberOfBlocks {
            let block = makeColorBlock(color: .white)
            blocks.append(block)
            stackView.addArrangedSubview(block)
        }
    }
    
    private func makeColorBlock(color: UIColor) -> UIView {
        let blockSize: CGFloat = 20
        let block = UIView()
        block.backgroundColor = color
        block.layer.cornerRadius = 5
        block.translatesAutoresizingMaskIntoConstraints = false
       
        block.layer.shadowColor = UIColor.black.cgColor
        block.layer.shadowOpacity = 0.1
        block.layer.shadowOffset = CGSize(width: 0, height: 3)
        block.layer.shadowRadius = 7
        
        block.heightAnchor.constraint(equalToConstant: blockSize).isActive = true
        block.widthAnchor.constraint(equalToConstant: blockSize).isActive = true
        
        return block
    }
    
    // MARK: - Public functions
    
    func setupColors(_ colors: [UIColor]?) {
        guard let safeColors = colors, colors?.count == numberOfBlocks else {
            return
        }
        
        for (i, color) in safeColors.enumerated() {
            blocks[i].backgroundColor = color
        }
    }
}
