//
//  UserDetailViewViewModel.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/25/21.
//

import Foundation
import Combine

final class UserDetailViewViewModel {
    @Published var imageURL: String? = nil
    @Published var fullName: String = "--"
    @Published var username: String = "--"
    @Published var birthDate: String = "--"
    @Published var generAndAge: String = "--"
    @Published var addressStreet: String = "--"
    @Published var addressCity: String = "--"
    @Published var phone: String = "--"
    @Published var email: String = "--"
    @Published var registeredAt: String = ""

    @Published var error: Error?

    private let userDetailService: UserDetailService

    private var cancellables: Set<AnyCancellable> = []

    init(userDetailService: UserDetailService) {
        self.userDetailService = userDetailService
        
        self.userDetailService.user
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] in
                    self?.imageURL = $0.avatarURL
                    self?.fullName = $0.firstName + " " + $0.lastName
                    self?.username = $0.username
                    self?.birthDate = "not implemented yet"
                    self?.generAndAge = "not implemented yet"
                    self?.registeredAt = "not implemented yet"
                    // TODO: finish setting up all published properties
                }
            )
            .store(in: &cancellables)
    }
}
