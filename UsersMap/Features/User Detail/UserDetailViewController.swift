//
//  UserDetailViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/24/21.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension UserDetailViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: Any
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! Self
        //viewController.viewModel = viewModel
        return viewController
    }
}
