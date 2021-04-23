//
//  UsersMapViewController.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit

final class UsersMapViewController: UIViewController {

    private(set) var viewModel: UsersListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UsersMapViewController {
    static func create(
        from storyboard: UIStoryboard = .main,
        withViewModel viewModel: UsersListViewModel
    ) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: "UsersMapViewController") as! Self
        viewController.viewModel = viewModel
        return viewController
    }
}
