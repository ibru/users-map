//
//  UsersCountViewModel.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation
import Combine

final class UsersCountViewModel: ObservableObject {

    @Published var initialCount: Int = 5
    
    private let usersCountService: UsersCountService
    @Published private var interactions: Interaction = .none

    init(
        usersCountService: UsersCountService,
        interactionsHandler: ((AnyPublisher<Interaction, Never>) -> Void)? = nil
    ) {
        self.usersCountService = usersCountService
        interactionsHandler?($interactions.eraseToAnyPublisher())

        usersCountService.usersCount.assign(to: &$initialCount)
    }

    func set(count: Int) {
        interactions = .chooseCount(count)
    }
}

extension UsersCountViewModel {
    enum Interaction: Equatable {
        case none
        case chooseCount(Int)
    }
}
