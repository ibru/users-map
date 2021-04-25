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

    @Published private var interactions: UsersListViewModel.Interaction = .none

    @Published private var userEntities: [User] = []

    private let usersService: UsersListService

    init(
        usersService: UsersListService,
        interactionsHandler: ((AnyPublisher<Interaction, Never>) -> Void)? = nil
    ) {
        self.usersService = usersService

        self.usersService.users
            .catch { error -> AnyPublisher<[User], Never>in
                self.error = error
                return Just([]).eraseToAnyPublisher()
            }
            .assign(to: &$userEntities)

        $userEntities
            .map { $0.map(UserInfo.init) }
            .assign(to: &$users)

        interactionsHandler?($interactions.eraseToAnyPublisher())
    }

    func select(user: UserInfo) {
        guard let selectedUser = userEntities.first(where: { $0.id == user.id }) else { return }
        interactions = .selectUser(selectedUser)
    }
}

extension UsersListViewModel {
    struct UserInfo: Identifiable {
        let id: String
        let avatarImageURL: URL?
        let fullName: String
        let userName: String

        init(user: User) {
            id = user.id
            avatarImageURL = user.avatarURL.map { URL(string: $0) } ?? nil
            fullName = "\(user.firstName) \(user.lastName)"
            userName = user.username
        }
    }
}

extension UsersListViewModel {
    enum Interaction: Equatable {
        case none
        case selectUser(User)
    }
}
