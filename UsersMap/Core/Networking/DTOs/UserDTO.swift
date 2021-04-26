//
//  UserDTO.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation

struct UserDTO: Codable {
    let gender: Gender
    var name: Name
    var location: Location
    let email: String
    let login: Login
    let picture: Picture
}

extension UserDTO {
    enum Gender: String, Codable {
        case male, female, nonBinary
    }
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    struct Location: Codable {
        struct Coordinates: Codable {
            let latitude: String
            let longitude: String
        }

        let coordinates: Coordinates
    }
    struct Login: Codable {
        let uuid: String
        let username: String
    }
    struct Picture: Codable {
        let thumbnail: String?
        let medium: String?
    }
}
