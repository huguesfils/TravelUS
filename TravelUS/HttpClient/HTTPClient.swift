//
//  HTTPClient.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

public protocol HTTPClient {
  func request<T: Decodable>(_ decodableType: T.Type, pathType: HTTPPathType) async -> Result<
    T, HTTPError
  >
}

struct DefaultHTTPClient: HTTPClient {

  private let session: URLSession

  init(session: URLSession = URLSession(configuration: .default)) {
    self.session = session
  }

  func request<T>(_ decodableType: T.Type, pathType: HTTPPathType) async -> Result<T, HTTPError>
  where T: Decodable {

    var components = URLComponents(string: pathType.path)!

    let queryItems = pathType.urlParameters?.compactMap { (key, value) -> URLQueryItem in
      return .init(name: key, value: value as? String)
    }

    components.queryItems = queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = pathType.method.rawValue.uppercased()

    if let bodyParameters = pathType.bodyParameters {
      request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
    }

    do {
      let (data, response) = try await session.data(for: request)
      if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Status Code: \(httpResponse.statusCode)")
      }
      if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
        print("Response JSON: \(json)")
      }
      let decode = try JSONDecoder().decode(decodableType.self, from: data)
      return .success(decode)
    } catch {
      return .failure(.error(code: 500, message: error.localizedDescription))
    }
  }
}
