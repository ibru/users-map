//
//  UserDetailService.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation
import Combine

public protocol UserDetailService {
    var user: AnyPublisher<User, Error> { get }
}
