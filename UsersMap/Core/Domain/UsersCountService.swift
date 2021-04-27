//
//  UsersCountService.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/27/21.
//

import Foundation
import Combine

public protocol UsersCountService {
    var usersCount: AnyPublisher<Int, Never> { get }
}
