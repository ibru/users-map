//
//  ServerConfiguration.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation

struct ServerConfiguration {
    static var current: ServerConfiguration = .staging

    var scheme: String
    var host: String
    var pathPrefix: String
}

extension ServerConfiguration {
    static var live: Self {
        .init(scheme: "https", host: "randomuser.me", pathPrefix: "/api")
    }

    static var staging: Self {
        .init(scheme: "https", host: "randomuser.me", pathPrefix: "/api")
    }
}
