//
//  WeatherQualityItemCell.swift
//  Weather
//
//  Created by Alexander Rubtsov on 12.09.2021.
//

import UIKit

class WeatherQualityItemView: UIView {

    // MARK: - Public properties

    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = Grid.pt4
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        return label
    }()

    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Grid.pt16)
        return label
    }()

    // MARK: - Private properties

    private let imageSizeConstant: CGFloat = Grid.pt24

    // MARK: - Construction

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
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

        imageView.heightAnchor.constraint(equalToConstant: imageSizeConstant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSizeConstant).isActive = true
    }
}
