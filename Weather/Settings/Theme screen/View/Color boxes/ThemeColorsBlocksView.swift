//
//  ThemeColorsBlocksView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ThemeColorsBlocksView: UIView {
    
    // MARK: - Private functions
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
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
        let blockSize: CGFloat = 25
        let block = UIView()
        block.backgroundColor = color
        block.layer.cornerRadius = 5
        block.translatesAutoresizingMaskIntoConstraints = false
        
        block.heightAnchor.constraint(equalToConstant: blockSize).isActive = true
        block.widthAnchor.constraint(equalToConstant: blockSize).isActive = true
        
        return block
    }
    
    // MARK: - Public functions
    
    func setupColors(_ colors: [UIColor]?) {
        guard let safeColors = colors else {
            let emptyLabel = UILabel()
            emptyLabel.text = "Empty"
            emptyLabel.textColor = .lightGray
            stackView.addArrangedSubview(emptyLabel)
            return
        }
        
        for (i, color) in safeColors.enumerated() {
            if i >= 5 {
                break
            }
            stackView.addArrangedSubview(makeColorBlock(color: color))
        }
    }
}
