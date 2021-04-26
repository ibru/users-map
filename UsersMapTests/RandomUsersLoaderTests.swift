//
//  RandomUsersLoaderTests.swift
//  UsersMapTests
//
//  Created by Jiri Urbasek on 4/26/21.
//

import XCTest
@testable import UsersMap
import Combine

class RandomUsersLoaderTests: XCTestCase {
    func testLoadSuccessResponse() {
        let loader = RandomUsersLoader(responseProvider: successJSON)

        let exp = expectation(description: "Publisher returned elements")
        let c = loader.loadUsers(count: 10)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    exp.fulfill()
                    XCTAssertEqual($0.count, 3)

                    XCTAssertEqual($0.first?.login.username, "whiteduck244")
                    XCTAssertEqual($0.last?.login.username, "bluezebra846")
                }
            )

        waitForExpectations(timeout: 0.1)
    }
}

typealias JSON = String
extension JSON: ResponseDataProviding {
    public func responseDataPublisher(for request: URLRequest) -> AnyPublisher<Data, URLError> {
        Just(self.data(using: .utf8)!)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

let successJSON: JSON = """
{"results":[{"gender":"female","name":{"title":"Mrs","first":"Hailey","last":"Lam"},"location":{"street":{"number":63,"name":"Stanley Way"},"city":"Chelsea","state":"Alberta","country":"Canada","postcode":"W7X 0L8","coordinates":{"latitude":"-65.8958","longitude":"158.0422"},"timezone":{"offset":"+6:00","description":"Almaty, Dhaka, Colombo"}},"email":"hailey.lam@example.com","login":{"uuid":"778c0d20-4949-497c-9d1e-32ada35dc67a","username":"whiteduck244","password":"adonis","salt":"JsKMEYeZ","md5":"1849fd4918659029bf36de9523d70875","sha1":"cc620146af2a755a20a878c26860a1314da9eb2a","sha256":"25ee4121acf828f01b6a905cfc0c38c30dc598c97f0337bae80b26486e9e31f5"},"dob":{"date":"1979-11-22T11:05:45.076Z","age":42},"registered":{"date":"2016-10-17T07:42:49.100Z","age":5},"phone":"238-734-6632","cell":"035-746-2861","id":{"name":"","value":null},"picture":{"large":"https://randomuser.me/api/portraits/women/60.jpg","medium":"https://randomuser.me/api/portraits/med/women/60.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/women/60.jpg"},"nat":"CA"},{"gender":"male","name":{"title":"Mr","first":"Jorre","last":"Van Brussel"},"location":{"street":{"number":109,"name":"Florijnburg"},"city":"Veen","state":"Gelderland","country":"Netherlands","postcode":84570,"coordinates":{"latitude":"35.4770","longitude":"-68.7935"},"timezone":{"offset":"+8:00","description":"Beijing, Perth, Singapore, Hong Kong"}},"email":"jorre.vanbrussel@example.com","login":{"uuid":"3059c793-da1d-4ce1-bec4-7bd08d4d48b5","username":"happygoose481","password":"foot","salt":"sGRudO0Z","md5":"07732fc74aab4c7cdac6e9beee24a979","sha1":"503b924f024752bff657535c7def4e62e2534ed2","sha256":"da0a7f529fdbb521ed655b0abe60e8a73f1366a02d1491c07b4ec01fa3ba99d7"},"dob":{"date":"1975-09-23T15:15:46.792Z","age":46},"registered":{"date":"2004-11-17T09:51:43.607Z","age":17},"phone":"(077)-436-1864","cell":"(265)-548-0431","id":{"name":"BSN","value":"99830164"},"picture":{"large":"https://randomuser.me/api/portraits/men/30.jpg","medium":"https://randomuser.me/api/portraits/med/men/30.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/30.jpg"},"nat":"NL"},{"gender":"male","name":{"title":"Mr","first":"Murat","last":"Durak"},"location":{"street":{"number":4784,"name":"Fatih Sultan Mehmet Cd"},"city":"Şırnak","state":"Antalya","country":"Turkey","postcode":19149,"coordinates":{"latitude":"-79.7486","longitude":"55.3116"},"timezone":{"offset":"+10:00","description":"Eastern Australia, Guam, Vladivostok"}},"email":"murat.durak@example.com","login":{"uuid":"fd565692-40cc-466a-bda7-3a986c0651ee","username":"bluezebra846","password":"love1","salt":"TtWJmpqh","md5":"0c4b9d27f017bd7cd77e61b37884eac2","sha1":"9ea46cf2fb170d50162a313388122dc84f3b4f71","sha256":"7722de8207207a7ff0ffad767201e83b6be6b0ab5df67d74f8e36c17a7b494a8"},"dob":{"date":"1944-08-29T10:28:40.346Z","age":77},"registered":{"date":"2003-05-16T02:11:40.119Z","age":18},"phone":"(650)-319-5399","cell":"(372)-558-1229","id":{"name":"","value":null},"picture":{"large":"https://randomuser.me/api/portraits/men/1.jpg","medium":"https://randomuser.me/api/portraits/med/men/1.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/1.jpg"},"nat":"TR"}],"info":{"seed":"57f9bdad1c559be7","results":3,"page":1,"version":"1.3"}}
"""
