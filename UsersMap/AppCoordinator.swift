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
        let containerVC = UIStoryboard.main.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController

        window.rootViewController = containerVC
    }
}

extension UIStoryboard {
    static var main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
