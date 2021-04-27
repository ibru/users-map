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

    private lazy var rootViewController = ContainerViewController.create(
        withMapController: createUsersMapViewController(),
        listController: createUsersListViewController(),
        viewModel: containerVieModel
    )

    private lazy var containerVieModel = ContainerViewModel(usersCountService: usersCountService) { interactions in
        interactions
            .sink { [weak self] in
                switch $0 {
                case .none: break
                case .selectCount: self?.presentUsersCountPicker()
                }
            }
            .store(in: &self.cancellables)
    }

    private lazy var usersListViewModel = UsersListViewModel(usersService: usersListService) { [weak self] interactions in
        guard let self = self else { return }

        interactions
            .sink { [weak self] in
                switch $0 {
                case .none: break
                case .selectUser(let user): self?.presentDetailFor(user: user)
                }
            }
            .store(in: &self.cancellables)
    }

    private lazy var usersCountViewModel = UsersCountViewModel(usersCountService: usersCountService) { [unowned self] interactions in
        interactions
            .compactMap {
                if case let .chooseCount(count) = $0 {
                    return count
                }
                return nil
            }
            .assign(to: &self.$usersCountPublisher)
    }


    @Published private var usersCountPublisher: Int = 5

    private lazy var usersCountService: UsersCountService = $usersCountPublisher.eraseToAnyPublisher()

    private lazy var usersListService: UsersListService = RandomUsersListService(
        usersCountService: usersCountService,
        usersLoader: RandomUsersLoader(responseProvider: URLSession.shared)
    )
}

extension AnyPublisher: UsersCountService where Output == Int, Failure == Never {
    public var usersCount: AnyPublisher<Int, Never> {
        self
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        window.rootViewController = rootViewController
    }

    func presentDetailFor(user: User) {
        let viewController = createUserDetailViewController(for: user)

        viewController.preferredContentSize = .init(width: window.bounds.width, height: 546)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = UserDetailViewController.TransitioningDelegate.modal(
            from: rootViewController,
            to: viewController
        )

        rootViewController.present(viewController, animated: true)
    }

    func presentUsersCountPicker() {
        let viewController = UsersCountViewController.create(withViewModel: usersCountViewModel)

        viewController.preferredContentSize = .init(width: window.bounds.width, height: 440)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = UserDetailViewController.TransitioningDelegate.modal(
            from: rootViewController,
            to: viewController
        )

        rootViewController.present(viewController, animated: true)
    }
}

extension AppCoordinator {
    func createUsersMapViewController() -> UsersMapViewController {
        UsersMapViewController.create(withViewModel: usersListViewModel)
    }

    func createUsersListViewController() -> UsersListViewController {
        UsersListViewController.create(withViewModel: usersListViewModel)
    }

    func createUserDetailViewController(for user: User) -> UserDetailViewController {
        UserDetailViewController.create(withViewModel: UserDetailViewViewModel(userDetailService: user))
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

extension User: UserDetailService {
    public var user: AnyPublisher<User, Error> {
        Just(self)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
