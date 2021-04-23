//
//  Coordinator.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import Foundation

protocol Coordinator: class {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func add(child: Coordinator) {
        childCoordinators.append(child)
    }

    func remove(child: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}
