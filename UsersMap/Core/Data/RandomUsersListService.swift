//
//  RandomUsersListService.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation
import Combine

protocol UsersLoader {
    func loadUsers(count: Int) -> AnyPublisher<[UserDTO], Error>
}

final class RandomUsersListService {
    private let usersCountService: UsersCountService
    private let usersLoader: UsersLoader

    init(
        usersCountService: UsersCountService,
        usersLoader: UsersLoader
    ) {
        self.usersCountService = usersCountService
        self.usersLoader = usersLoader
    }
}

extension RandomUsersListService: UsersListService {
    var users: AnyPublisher<[User], Error> {
        usersCountService.usersCount
            .flatMap { [unowned self] in
                self.usersLoader.loadUsers(count: $0)
            }
            .map { $0.map(User.init(userResponse:)) }
            .eraseToAnyPublisher()

    }
}

extension User {
    init(userResponse: UserDTO) {
        id = userResponse.login.uuid
        firstName = userResponse.name.first
        lastName = userResponse.name.last
        email = userResponse.email
        username = userResponse.login.username
        avatarURL = userResponse.picture.medium
        location = .init(
            latitude: Double(userResponse.location.coordinates.latitude)!,
            longitude: Double(userResponse.location.coordinates.longitude)!
        )
    }
}
