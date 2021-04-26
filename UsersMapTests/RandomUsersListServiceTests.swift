//
//  RandomUsersListServiceTests.swift
//  UsersMapTests
//
//  Created by Jiri Urbasek on 4/26/21.
//

import XCTest
@testable import UsersMap
import Combine

class RandomUsersListServiceTests: XCTestCase {
    func testUsersShouldLoadUsersFromUsersLoader() {
        let expectedUsers: [UserDTO] = [
            .mock(id: "1", username: "user1"),
            .mock(id: "2", username: "user2")
        ]
        var actualUsers: [User] = []

        let countPublisher = PassthroughSubject<Int, Never>()

        let loader = UsersLoaderStub(users: expectedUsers)

        let service = RandomUsersListService(
            usersCountPublisher: countPublisher.eraseToAnyPublisher(),
            usersLoader: loader
        )

        let c = service.users
            .sink(receiveCompletion: { _ in },
                  receiveValue: { actualUsers = $0 })

        countPublisher.send(3)

        XCTAssertEqual(actualUsers.count, 2)

        XCTAssertEqual(actualUsers.first?.id, expectedUsers[0].login.uuid)
        XCTAssertEqual(actualUsers.first?.username, expectedUsers[0].login.username)
        XCTAssertEqual(actualUsers.last?.id, expectedUsers[1].login.uuid)
        XCTAssertEqual(actualUsers.last?.username, expectedUsers[1].login.username)
    }

    func testUsersShouldEmitNextElementWhenUsersCountPublisherSendsNextValue() {
        let expectedUsers: [UserDTO] = [.mock(id: "2", username: "user2")]
        var actualUsers: [User] = []
        let countPublisher = PassthroughSubject<Int, Never>()

        let loader = UsersLoaderStub()
        let service = RandomUsersListService(
            usersCountPublisher: countPublisher.eraseToAnyPublisher(),
            usersLoader: loader
        )

        let c = service.users
            .sink(receiveCompletion: { _ in },
                  receiveValue: { actualUsers = $0 })

        countPublisher.send(3)

        loader.users = expectedUsers

        countPublisher.send(4)

        XCTAssertEqual(actualUsers.first?.id, expectedUsers[0].login.uuid)
        XCTAssertEqual(actualUsers.first?.username, expectedUsers[0].login.username)
    }
}

// MARK: -

class UsersLoaderStub: UsersLoader {

    var users: [UserDTO]
    init(users: [UserDTO] = []) { self.users = users }

    func loadUsers(count: Int) -> AnyPublisher<[UserDTO], Error> {
        Just(users)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension UserDTO {
    static func mock(
        id: String = "mockId",
        username: String = "mockuname",
        firstName: String = "Mock First",
        lastName: String = "Mock Last",
        email: String = "mock@mock.com"
    ) -> Self {
        .init(
            gender: .male,
            name: .init(title: "", first: firstName, last: lastName),
            location: .init(coordinates: .init(latitude: "1", longitude: "2")),
            email: email,
            login: .init(uuid: id, username: username),
            picture: .init(thumbnail: nil, medium: nil)
        )
    }
}
