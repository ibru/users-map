//
//  UsersListViewModelTests.swift
//  UsersMapTests
//
//  Created by Jiri Urbasek on 4/23/21.
//

import XCTest
@testable import UsersMap

class UsersListViewModelTests: XCTestCase {

    func testUsersLoadsUsigUsersListService() {
        let service = UsersListServiceSpy(
            users: [
                .mock(firstName: "John", lastName: "Doe"),
                .mock(firstName: "Jack", lastName: "Moore")
            ]
        )
        let viewModel = UsersListViewModel(usersService: service)
        let expectedUserNames = ["John Doe", "Jack Moore"]
        var actualUserNames = [String]()

        _ = viewModel.$users
            .map { $0.map { $0.fullName} }
            .sink { actualUserNames = $0 }

        XCTAssertTrue(service.usersCalled)
        XCTAssertEqual(actualUserNames, expectedUserNames)
    }

    // TODO: add more tests
}

// MARK: -
import Combine

extension User {
    static func mock(
        firstName: String = "mock first",
        lastName: String = "mock last",
        email: String = "mock@mock.com",
        username: String = "@mockuname",
        avatarURL: String? = nil
        ) -> Self {
        .init(
            firstName: firstName,
            lastName: lastName,
            email: email,
            username: username,
            avatarURL: avatarURL,
            location: .init(latitude: 1, longitude: 2)
        )
    }
}

class UsersListServiceStub: UsersListService {
    private let mockUsers: [User]

    init(users: [User]) {
        mockUsers = users
    }

    var users: AnyPublisher<[User], Error> {
        Just(mockUsers)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class UsersListServiceSpy: UsersListServiceStub {
    var usersCalled = false

    override var users: AnyPublisher<[User], Error> {
        usersCalled = true
        return super.users
    }
}
