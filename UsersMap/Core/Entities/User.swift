//
//  User.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/23/21.
//

import Foundation

public struct User {
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let avatarURL: String?
    let location: Location
}

extension User {
    struct Location {
        let latitude: Double
        let longitude: Double
    }
}
