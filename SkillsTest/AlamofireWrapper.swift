//
//  AlamofireWrapper.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import Foundation
import Alamofire
import Combine

enum NetworkError: Error {
    case badForm
    case networkError
}

struct AlamofireWrapper {
    static let shared = AlamofireWrapper()
    
    private init() { }
    
    private let baseURL = "https://storage.googleapis.com/apposing-interviews/"
    
    private func configureHeaders() -> HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func byGet<T: Codable>(url: String, parameters: [String: Any]? = nil) -> Future<T, NetworkError> {
        return Future<T, NetworkError>({ promise in
            AF.request("\(baseURL)\(url)", parameters: parameters, headers: configureHeaders())
                .validate(statusCode: 200..<300)
                .response(completionHandler: { response in
                    guard let data = response.data,
                          let data = try? JSONDecoder().decode(T.self, from: data) else {
                        promise(.failure(.badForm))
                        return
                    }
                    promise(.success(data))
                })
        })
    }
}
