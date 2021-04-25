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
        let service = UsersListServiceSpy(users: mockUsers)
        let viewModel = UsersListViewModel(usersService: service)
        let expectedUserNames = ["John Doe", "Jack Moore"]
        var actualUserNames = [String]()

        let c = viewModel.$users
            .map { $0.map { $0.fullName} }
            .sink { actualUserNames = $0 }

        XCTAssertTrue(service.usersCalled)
        XCTAssertEqual(actualUserNames, expectedUserNames)
    }

    func testSelectUserPublishesInteraction() {
        let service = UsersListServiceSpy(users: mockUsers)
        let expectedInteractions: [UsersListViewModel.Interaction] = [.none, .selectUser(mockUsers[1])]
        var actualInteractions: [UsersListViewModel.Interaction] = []
        var cancellable: AnyCancellable?

        let viewModel = UsersListViewModel(usersService: service) { interactions in
            cancellable = interactions
                .sink { actualInteractions.append($0) }
        }

        viewModel.select(user: UsersListViewModel.UserInfo(user: mockUsers[1]))

        XCTAssertEqual(actualInteractions, expectedInteractions)
    }

    // TODO: add more tests
}

extension UsersListViewModelTests {
    var mockUsers: [User] {
        [
            .mock(id: "id1", firstName: "John", lastName: "Doe"),
            .mock(id: "id2", firstName: "Jack", lastName: "Moore")
        ]
    }
}

// MARK: -
import Combine

extension User {
    static func mock(
        id: String = "mock id",
        firstName: String = "mock first",
        lastName: String = "mock last",
        email: String = "mock@mock.com",
        username: String = "@mockuname",
        avatarURL: String? = nil
        ) -> Self {
        .init(
            id: id,
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
