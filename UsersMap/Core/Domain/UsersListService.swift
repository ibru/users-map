//
//  UsersListService.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import Foundation
import Combine

public protocol UsersListService {
    var users: AnyPublisher<[User], Error> { get }
}


#if DEBUG
public struct MockUsersListService: UsersListService {
    private let mockUsers: [User]

    init(users: [User]) {
        mockUsers = users
    }

    public var users: AnyPublisher<[User], Error> {
        Just(mockUsers)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif
