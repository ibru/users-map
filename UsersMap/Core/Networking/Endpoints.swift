//
//  Endpoints.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation

struct Endpoint<Response: Decodable> {
    var serverConfiguration: ServerConfiguration
    var path: String
    var queryItems = [URLQueryItem]()

    init(
        configuration: ServerConfiguration = ServerConfiguration.current,
        path: String,
        queryItems: [URLQueryItem] = []
    ) {
        self.serverConfiguration = configuration
        self.path = path
        self.queryItems = queryItems
    }
}

struct InvalidEndpointError<Response: Decodable>: Error {
    let endpoint: Endpoint<Response>
}

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var results: Wrapped
}

extension Endpoint {
    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = serverConfiguration.scheme
        components.host = serverConfiguration.host
        components.path = serverConfiguration.pathPrefix + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else { return nil }

        let request = URLRequest(url: url)
        return request
    }
}

extension Endpoint where Response == [UserDTO] {
    static func users(count: Int) -> Self {
        Endpoint(
            path: "/",
            queryItems: [
                .init(name: "results", value: "\(count)"),
                .init(name: "nat", value: "de,fr,gb,nl,es")
            ]
        )
    }
}

import Combine

extension ResponseDataProviding {
    func publisher<R>(
        for endpoint: Endpoint<R>,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<R, Error> {
        guard let request = endpoint.makeRequest() else {
            return Fail(
                error: InvalidEndpointError(endpoint: endpoint)
            )
            .eraseToAnyPublisher()
        }

        return responseDataPublisher(for: request)
            .decode(type: NetworkResponse<R>.self, decoder: decoder)
            .map(\.results)
            .eraseToAnyPublisher()
    }
}
