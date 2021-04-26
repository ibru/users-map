//
//  RandomUsersLoader.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation
import Combine

struct RandomUsersLoader {
    let responseProvider: ResponseDataProviding

    init(responseProvider: ResponseDataProviding) {
        self.responseProvider = responseProvider
    }

    func loadUsers(count: Int) -> AnyPublisher<[UserDTO], Error> {
        responseProvider.publisher(for: .users(count: count))
    }
}

extension RandomUsersLoader: UsersLoader {}
