//
//  UsersEndpointTests.swift
//  UsersMapTests
//
//  Created by Jiri Urbasek on 4/26/21.
//

import XCTest
@testable import UsersMap

class UsersEndpointTests: XCTestCase {
    func testCorrectURL() {
        var endpoint = Endpoint.users(count: 3)
        endpoint.serverConfiguration = .init(scheme: "http", host: "example.com", pathPrefix: "/api/1")

        XCTAssertEqual(endpoint.makeRequest()?.url?.absoluteString, "http://example.com/api/1/?results=3&nat=de,fr,gb,nl,es")
    }
}
