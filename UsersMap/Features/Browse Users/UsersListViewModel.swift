//
//  UsersListViewModel.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import Foundation
import Combine

final class UsersListViewModel: ObservableObject {
    @Published var users: [UserInfo] = []
    @Published var error: Error?

    private let usersService: UsersListService

    init(usersService: UsersListService) {
        self.usersService = usersService

        self.usersService.users
            .catch { error -> AnyPublisher<[User], Never>in
                self.error = error
                return Just([]).eraseToAnyPublisher()
            }
            .map {
                $0.map {
                    UserInfo(
                        avatarImageURL: $0.avatarURL.map { URL(string: $0) } ?? nil,
                        fullName: "\($0.firstName) \($0.lastName)",
                        userName: $0.username
                    )
                }
            }
            .assign(to: &$users)
    }
}

extension UsersListViewModel {
    struct UserInfo {
        let avatarImageURL: URL?
        let fullName: String
        let userName: String
    }
}
