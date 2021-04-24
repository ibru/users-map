//
//  AppCoordinator.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import UIKit
import Combine

final class AppCoordinator {
    var childCoordinators: [Coordinator] = []

    private let window: UIWindow

    private var cancellables: Set<AnyCancellable> = []

    init(for window: UIWindow) {
        self.window = window
    }

    private lazy var usersListViewModel: UsersListViewModel = {
        let viewModel = UsersListViewModel(usersService: usersListService)

        viewModel.$interactions
            .sink { [weak self] in
                switch $0 {
                case .none: break
                case .selectUser(let user): self?.presentDetailFor(user: user)
                }
            }
            .store(in: &cancellables)

        return viewModel
    }()

    private lazy var usersListService: UsersListService = {
        MockUsersListService(users: User.mocks)
    }()
}

extension AppCoordinator: Coordinator {
    func start() {
        let containerVC = ContainerViewController.create(
            withMapController: createUsersMapViewController(),
            listController: createUsersListViewController()
        )

        window.rootViewController = containerVC
    }

    func presentDetailFor(user: User) {

    }
}

extension AppCoordinator {
    func createUsersMapViewController() -> UsersMapViewController {
        UsersMapViewController.create(withViewModel: usersListViewModel)
    }

    func createUsersListViewController() -> UsersListViewController {
        UsersListViewController.create(withViewModel: usersListViewModel)
    }
}

extension UIStoryboard {
    static var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

extension User {
    static var mocks: [User] {
        [
            .init(id: "id1", firstName: "Debra", lastName: "Debra", email: "debra@wade", username: "ebravade", avatarURL: nil, location: .init(latitude: 1, longitude: 1)),
            .init(id: "id2", firstName: "Dwight", lastName: "King", email: "debra@wade", username: "ebravade", avatarURL: nil, location: .init(latitude: 1, longitude: 1))
        ]
    }
}
