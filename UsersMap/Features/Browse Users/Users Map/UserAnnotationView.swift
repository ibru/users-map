//
//  UserAnnotationView.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/28/21.
//

import Foundation
import MapKit
import SDWebImage

class UserAnnotationView: MKAnnotationView {
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = Theme.current.fontTheme.captionFont()
        label.textColor = Theme.current.colorTheme.primaryFontColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameLabelBGView: UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .white
        return bgView
    }()

    private lazy var imageBGView: UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .white
        return bgView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear

        addSubview(nameLabelBGView)
        nameLabelBGView.addSubview(nameLabel)

        addSubview(imageBGView)
        imageBGView.addSubview(imageView)

        NSLayoutConstraint.activate([
            nameLabelBGView.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabelBGView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameLabelBGView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nameLabelBGView.heightAnchor.constraint(equalToConstant: 22),
        ])

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: nameLabelBGView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: nameLabelBGView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            imageBGView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageBGView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageBGView.heightAnchor.constraint(equalToConstant: 60),
            imageBGView.widthAnchor.constraint(equalToConstant: 60),
        ])

        imageView.layer.cornerRadius = 27
        imageView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: imageBGView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBGView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageBGView.widthAnchor, constant: -6),
            imageView.heightAnchor.constraint(equalTo: imageBGView.heightAnchor, constant: -6)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.sd_cancelCurrentImageLoad()
        
        nameLabel.text = nil
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let annotation = annotation as? UsersMapViewController.UserAnnotation else { return }

        nameLabel.text = annotation.title

        if let imageURL = annotation.imageURL {
            imageView.sd_setImage(with: imageURL, completed: nil)
        } else {
            imageView.backgroundColor = UIColor.gray // TOOD: set some default "unknown" image
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        frame.size = intrinsicContentSize

        // annotation coordinate should point to center of image view
        centerOffset = CGPoint(x: 0, y: imageBGView.frame.height - frame.height)

        imageBGView.makeRoundedAndShadowed(cornerRadius: 30)
        nameLabelBGView.makeRoundedAndShadowed(cornerRadius: 11)
    }

    override var intrinsicContentSize: CGSize {
        .init(width: 71, height: 88)
    }
}
