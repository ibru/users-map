//
//  UserDetailViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/24/21.
//

import UIKit
import Combine

class UserDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!

    @IBOutlet weak var genderAgeLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!

    @IBOutlet weak var registeredDateLabel: UILabel!

    @IBOutlet var contentBoxes: [UIView]!

    private(set) var viewModel: UserDetailViewViewModel!

    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()

        view.layer.cornerRadius = 30

        contentBoxes.forEach {
            $0.layer.backgroundColor = UIColor(red: 0.964, green: 0.964, blue: 0.964, alpha: 1).cgColor
            $0.layer.cornerRadius = 8
            $0.backgroundColor = Theme.main.colorTheme.lightGray()
        }

        avatarImageView.layer.cornerRadius = 36

        fullNameLabel.font = Theme.main.fontTheme.titleFont()
        fullNameLabel.textColor = Theme.main.colorTheme.primaryFontColor()

        nicknameLabel.font = Theme.main.fontTheme.headlineFont()
        nicknameLabel.textColor = Theme.main.colorTheme.secondaryFontColor()

        Theme.main.style(headlineLabel: genderAgeLabel)
        Theme.main.style(captionLabel: birthDateLabel)

        registeredDateLabel.font = Theme.main.fontTheme.footnoteFont()
        registeredDateLabel.textColor = Theme.main.colorTheme.secondaryFontColor()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$imageURL
            .sink { [weak self] urlString in
                if let urlString = urlString {
                    // load image using https://github.com/SDWebImage/SDWebImage
                    //avatarImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder.png"))
                } else {
                    self?.avatarImageView.backgroundColor = UIColor.gray // TOOD: set some default "unknown" image
                }
            }
            .store(in: &cancellables)

        viewModel.$fullName
            .assign(to: \.text!, on: fullNameLabel)
            .store(in: &cancellables)

        viewModel.$username
            .assign(to: \.text!, on: nicknameLabel)
            .store(in: &cancellables)

        viewModel.$generAndAge
            .assign(to: \.text!, on: genderAgeLabel)
            .store(in: &cancellables)

        viewModel.$birthDate
            .assign(to: \.text!, on: birthDateLabel)
            .store(in: &cancellables)

        viewModel.$registeredAt
            .assign(to: \.text!, on: registeredDateLabel)
            .store(in: &cancellables)

    }
}

extension UserDetailViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: UserDetailViewViewModel
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! Self
        viewController.viewModel = viewModel

        return viewController
    }
}

struct Theme {
    let colorTheme: ColorTheme
    let fontTheme: FontTheme
}

extension Theme {
    static var main: Self = {
        .init(colorTheme: .main, fontTheme: .main)
    }()
}

extension Theme {
    func style(headlineLabel: UILabel) {
        headlineLabel.textColor = colorTheme.primaryFontColor()
        headlineLabel.font = fontTheme.headlineFont()
    }

    func style(captionLabel: UILabel) {
        captionLabel.textColor = colorTheme.secondaryFontColor()
        captionLabel.font = fontTheme.captionFont()
    }
}

struct ColorTheme {
    let primaryFontColor: () -> UIColor
    let secondaryFontColor: () -> UIColor
    let lightGray: () -> UIColor
}

extension ColorTheme {
    static var main: Self {
        .init(
            primaryFontColor: { UIColor(red: 0.165, green: 0.18, blue: 0.263, alpha: 1) },
            secondaryFontColor: { UIColor(red: 0.742, green: 0.742, blue: 0.742, alpha: 1) },
            lightGray: { UIColor(red: 0.964, green: 0.964, blue: 0.964, alpha: 1) }
        )
    }
}

struct FontTheme {
    let titleFont: () -> UIFont
    let headlineFont: () -> UIFont
    let headlineBolderFont: () -> UIFont
    let captionFont: () -> UIFont
    let footnoteFont: () -> UIFont
}

extension Theme {

}

extension FontTheme {
    static var main: Self {
        .init(
            titleFont: { UIFont(name: "CircularStd-Bold", size: 24)! },
            headlineFont: { UIFont(name: "CircularStd-Book", size: 17)! },
            headlineBolderFont: { UIFont(name: "CircularStd-Medium", size: 17)! },
            captionFont: { UIFont(name: "CircularStd-Book", size: 15)! },
            footnoteFont: { UIFont(name: "CircularStd-Book", size: 12)! }
        )
    }
}
