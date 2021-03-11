//
//  LinkCollectionViewCell.swift
//  FavouriteProjectsSection
//
//  Created by Steven Curtis on 19/02/2021.
//

import UIKit
import SDWebImage

class SongCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        static let placeholderImage = "placeholder"
    }
    lazy var imageView = UIImageView()
    lazy var heartImageView = UIImageView()

    lazy var titleLabel = UILabel()
    lazy var backgroundTitleView = UIView()

    var topRightTap: (() -> Void)?
    var onTap: (() -> Void)?
    var topRightAction: ButtonModel?

    public func configure(
        with title: String,
        pictureURLString: String?,
        onTap: (() -> Void)?,
        topRightAction: ButtonModel? = nil
    ) {
        self.onTap = onTap
        titleLabel.text = title
        if let picture = pictureURLString, let imgURL = URL(string: picture) {
            imageView.sd_setImage(
                with: imgURL
            )
        }
        if let action = topRightAction {
            topRightTap = action.action
            if let icon = action.icon {
            heartImageView.image = (
                UIImage(
                    systemName: icon
                )?.withTintColor(
                    .red,
                    renderingMode: .alwaysOriginal
                )
            )
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.placeholderImage)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true

        addSubview(heartImageView)
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getButtonTapped))
        heartImageView.addGestureRecognizer(tapGesture)
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        imageView.addGestureRecognizer(cellTapGesture)

        addSubview(backgroundTitleView)
        backgroundTitleView.translatesAutoresizingMaskIntoConstraints = false
        backgroundTitleView.backgroundColor = .systemGray
        backgroundTitleView.alpha = 0.8

        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .white

        self.clipsToBounds = true
        self.layer.cornerRadius = 15

        setupConstraints()
    }

    func setupConstraints() {
        let titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        let titleTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            heartImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            heartImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            heartImageView.heightAnchor.constraint(equalToConstant: 30),
            heartImageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLeadingConstraint,
            titleTrailingConstraint,
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            backgroundTitleView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundTitleView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundTitleView.heightAnchor.constraint(equalToConstant: 25)
        ])

        titleLeadingConstraint.priority = .defaultHigh
        titleTrailingConstraint.priority = .defaultHigh
    }

    @IBAction func getButtonTapped(_ sender: UIButton) {
        topRightTap?()
    }

    @objc func didTouchDown(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            topRightTap?()
        }
    }

    @IBAction func cellTapped() {
        onTap?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            return layoutAttributes
    }

    override func prepareForReuse() {
        heartImageView.sd_cancelCurrentImageLoad()
    }
}
