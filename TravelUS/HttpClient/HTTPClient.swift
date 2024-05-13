//
//  HTTPClient.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

public protocol HTTPClient {
    func request<T: Decodable>(_ decodableType: T.Type, pathType: HTTPPathType) async -> Result<T, HTTPError>
}

struct DefaultHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func request<T>(_ decodableType: T.Type, pathType: HTTPPathType) async -> Result<T, HTTPError> where T : Decodable {
        
        var request = URLRequest(url: URL(string: pathType.path)!)
        
        request.httpMethod = pathType.method.rawValue.uppercased()
        
        do {
            let (data, _) = try await session.data(for: request)
            let decode = try JSONDecoder().decode(decodableType.self, from: data)
            
            return .success(decode)
        } catch {
            
            return .failure(.error(code: 500, message: error.localizedDescription))
        }
    }
}
