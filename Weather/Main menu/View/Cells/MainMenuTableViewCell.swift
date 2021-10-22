//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {

    // MARK: - Private properties

    private let cellShapeMask = UIView()

    private var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var leftStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var rightStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Public properties
    
    let gradient = CAGradientLayer()
    
    var weatherBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var degreeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()

    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var conditionImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override var isHighlighted: Bool {
        didSet {
            bounce(isHighlighted) // Animate this cell by highlight
        }
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = "MainMenuTableViewCell"
        selectionStyle = .none

        // Setting up cell appearance
        DesignManager.setBackgroundStandartShape(layer: weatherBackgroundView.layer)

        // Making cells shadow be able to spill over other cells
        layer.masksToBounds = false
        backgroundColor = .clear

        // Setting up gradient layer
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = DesignManager.getStandartGradientColor(withStyle: .blank)

        weatherBackgroundView.layer.insertSublayer(gradient, at: 0) // Adding gradient at the bottom

        leftStackView.addArrangedSubview(cityNameLabel)
        leftStackView.addArrangedSubview(timeLabel)

        rightStackView.addArrangedSubview(conditionImage)
        rightStackView.addArrangedSubview(degreeLabel)

        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)

        addSubview(weatherBackgroundView)
        weatherBackgroundView.addSubview(mainStackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        // Configuring gradient frame when views calculating
        gradient.frame = weatherBackgroundView.bounds
        DesignManager.setBackgroundStandartShape(layer: gradient)
        setUpConstraints()
    }

    // MARK: - Private functions

    // Cell bounce animation
    private func bounce(_ bounce: Bool) {
        // Animation settings and allowing user to interact while the animation is running
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        // Scale in and out
                        self.transform = bounce ? CGAffineTransform(scaleX: 0.95, y: 0.95) :
                            CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                       }, completion: nil)
    }

    private func setUpConstraints() {
        // Background
        weatherBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        let weatherBackgroundViewBottomConstraint = weatherBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        weatherBackgroundViewBottomConstraint.priority = UILayoutPriority(999)
        weatherBackgroundViewBottomConstraint.isActive = true
        weatherBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        weatherBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        

        // Condition image
        conditionImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        conditionImage.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

        // Degree label
        let degreeLabelConstraint = degreeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 90)
        degreeLabelConstraint.isActive = true
        

        // MainStackView
        mainStackView.topAnchor.constraint(equalTo: weatherBackgroundView.topAnchor, constant: 10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo:
                                                weatherBackgroundView.bottomAnchor, constant: -10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo:
                                                weatherBackgroundView.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo:
                                                    weatherBackgroundView.trailingAnchor, constant: -20).isActive = true
    }

    // MARK: - Public functions

    // Cell animation by user interaction
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
