//
//  ResponseDataProviding.swift
//  UsersMap
//
//  Created by Jiri Urbasek on 4/26/21.
//

import Foundation
import Combine

protocol ResponseDataProviding {
    func responseDataPublisher(for request: URLRequest) -> AnyPublisher<Data, URLError>
}

extension URLSession: ResponseDataProviding {
    func responseDataPublisher(for request: URLRequest) -> AnyPublisher<Data, URLError> {
        dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .mapError { ($0 as? URLError).map { $0 } ?? URLError(.unknown) }
            .eraseToAnyPublisher()
    }
}
