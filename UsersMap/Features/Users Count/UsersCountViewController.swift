//
//  UsersCountViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import UIKit

class UsersCountViewController: UIViewController {

    var viewModel: UsersCountViewModel!

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var numberOfUsersLabel: UILabel!

    override func loadView() {
        super.loadView()

        doneButton.backgroundColor = Theme.current.colorTheme.controlsTint()
        doneButton.layer.cornerRadius = 24

        textField.font = Theme.current.fontTheme.usersCountFont()
        textField.textColor = Theme.current.colorTheme.primaryFontColor()

        numberOfUsersLabel.font = UIFont(name: "CircularStd-Book", size: 20)!
        numberOfUsersLabel.textColor = Theme.current.colorTheme.secondaryFontColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.text = "\(viewModel.initialCount)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        textField.becomeFirstResponder()
    }

    @IBAction func textFieldEditingChanged(_ sender: Any) {
    }

    @IBAction func doneButtonTouched(_ sender: Any) {
        dismiss(animated: true)

        textField.resignFirstResponder()

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) {
            self.doneButton.frame = CGRect(x: self.doneButton.frame.midX, y: 0, width: 1, height: 1)
            self.doneButton.transform = .init(rotationAngle: CGFloat(Double.pi))
            self.doneButton.alpha = 0
        } completion: { _ in }


        guard let text = textField.text, let count = Int(text) else { return }

        viewModel.set(count: count)
    }
}

extension UsersCountViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: UsersCountViewModel
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UsersCountViewController") as! Self
        viewController.viewModel = viewModel
        return viewController
    }
}
