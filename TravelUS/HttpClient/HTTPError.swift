//
//  HTTPError.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

public enum HTTPError: Error {
    case error(code: Int, message: String)
    case unAuthorized
    case mappingError
    case noNetwork
    case serverNotAvailable
    case unknown
    case customResponse(Data)
}
