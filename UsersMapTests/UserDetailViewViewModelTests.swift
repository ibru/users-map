//
//  UserDetailViewViewModelTests.swift
//  UsersMapTests
//
//  Created by Jiri Urbasek on 4/26/21.
//

import XCTest
@testable import UsersMap
import Combine

class UserDetailViewViewModelTests: XCTestCase {

    func testFullNameShouldBeTakenFromUsersFirstAndLastName() {
        let service = UserDetailServiceStub(user: .mock(id: "1", firstName: "John", lastName: "Doe"))
        let viewModel = UserDetailViewViewModel(userDetailService: service)

        XCTAssertEqual(viewModel.fullName, "John Doe")
    }
}

// MARK: -

class UserDetailServiceStub: UserDetailService {
    init(user: User) {
        self.user =
            Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
    }
    var user: AnyPublisher<User, Error>
}
