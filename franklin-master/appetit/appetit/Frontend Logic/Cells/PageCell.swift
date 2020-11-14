//
//  PageCell.swift
//  appetit
//
//  Created by codeplus on 3/29/20.
//  Copyright © 2020 Mark Kang. All rights reserved.
//

import SnapKit
import UIKit

/// A cell for a page in the login flow
final class PageCell: UICollectionViewCell {
    /// The information about the page
    var page: Page? {
        didSet {
            guard let page = page else {
                return
            }

            let imageName =
                UIDevice.current.orientation.isLandscape ?
                page.imageName + "_landscape" :
                page.imageName

            imageView.image = UIImage(named: imageName)

            let color = UIColor(white: 0.2, alpha: 1)
            let attributedText = NSMutableAttributedString(
                string: page.title,
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(
                        ofSize: 20,
                        weight: UIFont.Weight.medium
                    ),
                    NSAttributedString.Key.foregroundColor: color
                ]
            )

            attributedText.append(
                NSAttributedString(
                    string: "\n\n\(page.message)",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: color
                    ]
                )
            )

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let length = attributedText.string.count
            attributedText.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: length)
            )

            textLabel.attributedText = attributedText

            // Recompute constraints with new text and image
            setNeedsUpdateConstraints()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    override func updateConstraints() {
        imageView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
            //make.width.equalToSuperview().inset(40)
            make.width.equalTo(300)
            make.height.equalTo(450)
        }

        lineSeparatorView.snp.remakeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalTo(background.snp.top)
            make.height.equalTo(1)
        }

        background.snp.remakeConstraints { make in
            //make.top.equalTo(textLabel).offset(-20)
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.left.right.bottom.equalToSuperview()
        }

        textLabel.snp.remakeConstraints { make in
            make.width.equalToSuperview().inset(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.top.equalTo(background.snp.top)
        }

        super.updateConstraints()
    }

    /// Optional image to display
    let imageView: UIImageView = {
        let iv = UIImageView()

        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true

        return iv
    }()

    /// Background around text and bottom toolbar
    private let background: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor(
            displayP3Red: 252.0 / 255.0,
            green: 244.0 / 255.0,
            blue: 236.0 / 255.0,
            alpha: 1
        )

        return view
    }()

    /// Text to display to the user
    private let textLabel: UILabel = {
        let label = UILabel()

        label.numberOfLines = 0

        return label
    }()

    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()

    func setupViews() {
        addSubview(imageView)
        addSubview(background)
        addSubview(textLabel)
        addSubview(lineSeparatorView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
