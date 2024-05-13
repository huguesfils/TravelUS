//
//  HTTPPathType.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

public enum HTTPUrlMethod: String {
    case get, post, delete, patch, put
}

public protocol HTTPPathType {
    /// The path URL
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPUrlMethod { get }
    
    /// body parameters passed in HTTP Request
    var bodyParameters: [String: Any]? { get }
    
    /// url parameters passed in HTTP Request
    var urlParameters: [String: Any]? { get }
}

