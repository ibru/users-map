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
            $0.backgroundColor = Theme.current.colorTheme.lightGray()
        }

        avatarImageView.layer.cornerRadius = 36

        fullNameLabel.font = Theme.current.fontTheme.titleFont()
        fullNameLabel.textColor = Theme.current.colorTheme.primaryFontColor()

        nicknameLabel.font = Theme.current.fontTheme.headlineFont()
        nicknameLabel.textColor = Theme.current.colorTheme.secondaryFontColor()

        Theme.current.style(headlineLabel: genderAgeLabel)
        Theme.current.style(captionLabel: birthDateLabel)

        registeredDateLabel.font = Theme.current.fontTheme.footnoteFont()
        registeredDateLabel.textColor = Theme.current.colorTheme.secondaryFontColor()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$imageURL
            .sink { [weak self] urlString in
                if let urlString = urlString {
                    self?.avatarImageView.sd_setImage(with: URL(string: urlString), completed: nil)
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
