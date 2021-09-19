//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Александр on 14.06.2021.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    // MARK: - Public properties

    var topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Private properties

    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Construction

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(bottomLabel)
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
        
        let stackViewLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        stackViewLeadingConstraint.priority = UILayoutPriority(999)
        stackViewLeadingConstraint.isActive = true
        
        let stackViewTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        stackViewTrailingConstraint.priority = UILayoutPriority(999)
        stackViewTrailingConstraint.isActive = true
        
        let imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 25)
        imageViewWidthConstraint.priority = UILayoutPriority(999)
        imageViewWidthConstraint.isActive = true
        
        let imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 25)
        imageViewHeightConstraint.priority = UILayoutPriority(999)
        imageViewHeightConstraint.isActive = true
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
                                                                                -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        layoutAttributes.bounds.size.width = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        return layoutAttributes
    }
}
