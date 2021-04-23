//
//  AppCoordinator.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit

final class AppCoordinator {
    var childCoordinators: [Coordinator] = []

    private let window: UIWindow

    init(for window: UIWindow) {
        self.window = window
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        let containerVC = ContainerViewController.create(
            withMapController: createUsersMapViewController(),
            listController: createUsersListViewController()
        )

        window.rootViewController = containerVC
    }
}

extension AppCoordinator {
    func createUsersMapViewController() -> UsersMapViewController {
        UsersMapViewController.create(withViewModel: "not implemented yet")
    }

    func createUsersListViewController() -> UsersListViewController {
        UsersListViewController.create(withViewModel: "Not implemented yet")
    }
}

extension UIStoryboard {
    static var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
