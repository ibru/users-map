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
    
    @Published private var interactions: UsersCountViewModel.Interaction = .none

    init(
        interactionsHandler: ((AnyPublisher<Interaction, Never>) -> Void)? = nil
    ) {
        interactionsHandler?($interactions.eraseToAnyPublisher())
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
