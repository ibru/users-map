//
//  UserDTOTests.swift
//  UsersMapTests
//
//  Created by Jiri Urbasek on 4/26/21.
//

import XCTest
@testable import UsersMap

class UserDTOTests: XCTestCase {
    func testDecodeFromJSON() throws {
        let user = try JSONDecoder().decode(UserDTO.self, from: jsonData)

        XCTAssertEqual(user.gender, .male)
        XCTAssertEqual(user.name.first, "Dwight")
        XCTAssertEqual(user.name.last, "King")
        XCTAssertEqual(user.location.coordinates.latitude, "8.2565")
        XCTAssertEqual(user.location.coordinates.longitude, "-54.5231")
        XCTAssertEqual(user.login.uuid, "485ce87f-9a9f-463d-8e08-36d6c3838cc1")
        XCTAssertEqual(user.login.username, "beautifulleopard309")
        XCTAssertEqual(user.email, "dwight.king@example.com")
        XCTAssertEqual(user.picture.thumbnail, "https://randomuser.me/api/portraits/thumb/men/39.jpg")
        XCTAssertEqual(user.picture.medium, "https://randomuser.me/api/portraits/med/men/39.jpg")
    }

    func testMappingToUserEntity() {
        let userDTO = UserDTO(
            gender: .male,
            name: .init(title: "", first: "John", last: "Doe"),
            location: .init(coordinates: .init(latitude: "11.111", longitude: "-22.222")),
            email: "john@doe.com",
            login: .init(uuid: "1234ANCD", username: "johndoe123"),
            picture: .init(thumbnail: "thumbnailpicurl", medium: "mediumpicurl")
        )

        let user = User(userResponse: userDTO)

        XCTAssertEqual(user.id, userDTO.login.uuid)
        XCTAssertEqual(user.firstName, userDTO.name.first)
        XCTAssertEqual(user.lastName, userDTO.name.last)
        XCTAssertEqual(user.avatarURL, userDTO.picture.thumbnail)
        XCTAssertEqual(user.email, userDTO.email)
        XCTAssertEqual(user.username, userDTO.login.username)
        XCTAssertEqual(user.location.latitude, Double(userDTO.location.coordinates.latitude))
        XCTAssertEqual(user.location.longitude, Double(userDTO.location.coordinates.longitude))
    }
}

private let jsonData = """
{
    "gender": "male",
    "name": {
        "title": "Mr",
        "first": "Dwight",
        "last": "King"
    },
    "location": {
        "street": {
            "number": 7797,
            "name": "The Grove"
        },
        "city": "Manchester",
        "state": "Hampshire",
        "country": "United Kingdom",
        "postcode": "XM03 2XX",
        "coordinates": {
            "latitude": "8.2565",
            "longitude": "-54.5231"
        },
        "timezone": {
            "offset": "-3:00",
            "description": "Brazil, Buenos Aires, Georgetown"
        }
    },
    "email": "dwight.king@example.com",
    "login": {
        "uuid": "485ce87f-9a9f-463d-8e08-36d6c3838cc1",
        "username": "beautifulleopard309",
        "password": "tigers",
        "salt": "MNK8zn1a",
        "md5": "3d39c1c9c49f4dd4c2e9b753a34502fc",
        "sha1": "fbe3df823565136062400ee97bcb6b7f939ee98c",
        "sha256": "2f474e66ca55281f861e605037d5622471b8c172e684457064c949cd0fa0d776"
    },
    "dob": {
        "date": "1966-09-09T06:05:34.370Z",
        "age": 55
    },
    "registered": {
        "date": "2016-11-25T00:48:50.849Z",
        "age": 5
    },
    "phone": "016977 8430",
    "cell": "0712-789-681",
    "id": {
        "name": "NINO",
        "value": "LB 19 21 70 T"
    },
    "picture": {
        "large": "https://randomuser.me/api/portraits/men/39.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/39.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/39.jpg"
    },
    "nat": "GB"
}
""".data(using: .utf8)!
