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
        UsersMapViewController.create(
            withViewModel: UsersListViewModel(
                usersService: MockUsersListService(users: User.mocks)
            )
        )
    }

    func createUsersListViewController() -> UsersListViewController {
        UsersListViewController.create(
            withViewModel: UsersListViewModel(
                usersService: MockUsersListService(users: User.mocks)
            )
        )
    }
}

extension UIStoryboard {
    static var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

extension User {
    static var mocks: [User] {
        [
            .init(firstName: "Debra", lastName: "Debra", email: "debra@wade", username: "ebravade", avatarURL: nil, location: .init(latitude: 1, longitude: 1)),
            .init(firstName: "Dwight", lastName: "King", email: "debra@wade", username: "ebravade", avatarURL: nil, location: .init(latitude: 1, longitude: 1))
        ]
    }
}
