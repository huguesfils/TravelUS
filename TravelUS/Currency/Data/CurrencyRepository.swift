//
//  CurrencyRepository.swift
//  TravelUS
//
//  Created by Hugues Fils on 07/03/2024.
//

import Foundation

protocol CurrencyRepository {
  func getCurrency() async -> Result<Currency, DomainError>
}

struct DefaultCurrencyRepository: CurrencyRepository {

  let httpClient: HTTPClient
  let baseUrl: String

  func getCurrency() async -> Result<Currency, DomainError> {
    return await httpClient.request(
      CurrencyResponse.self, pathType: CurrencyHttpPathType(baseUrl: baseUrl)
    )
    .map { $0.toDomain() }
    .mapError { $0.toDomain() }
  }
}

struct CurrencyHttpPathType: HTTPPathType {
  let baseUrl: String

  var path: String {
    return baseUrl
  }

  var method: HTTPUrlMethod {
    return .get
  }

  var bodyParameters: [String: Any]? {
    return nil
  }

  var urlParameters: [String: Any]? {
    return ["app_id": APIKeys.currencyApiKey]
  }

  var headers: [String: String]? {
    return nil
  }
}

extension HTTPError {
  func toDomain() -> DomainError {
    switch self {
    case .error(let code, let message):
      return .error(code: code, message: message)
    case .unAuthorized:
      return .unAuthorized
    case .mappingError, .unknown, .customResponse:
      return .unknown
    case .noNetwork:
      return .noNetwork
    case .serverNotAvailable:
      return .serverNotAvailable
    }
  }
}
