//
//  ContainerViewModel.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation
import Combine

final class ContainerViewModel: ObservableObject {

    @Published var usersCount: Int = 5

    private let usersCountService: UsersCountService
    @Published private var interactions: Interaction = .none

    init(
        usersCountService: UsersCountService,
        interactionsHandler: ((AnyPublisher<Interaction, Never>) -> Void)? = nil
    ) {
        self.usersCountService = usersCountService
        interactionsHandler?($interactions.eraseToAnyPublisher())

        usersCountService.usersCount.assign(to: &$usersCount)
    }

    func changeUsersCount() {
        interactions = .selectCount
    }
}

extension ContainerViewModel {
    enum Interaction: Equatable {
        case none
        case selectCount
    }
}
