//
//  DomainError.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

public enum DomainError: Error {
  case error(code: Int, message: String)
  case unAuthorized
  case noNetwork
  case serverNotAvailable
  case unknown
}
