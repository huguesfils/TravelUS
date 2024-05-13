//
//  CurrencyResponse.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

struct CurrencyResponse: Decodable {
    var base: String
    var rates: [String: Double]
}

extension CurrencyResponse {
    func toDomain() -> Currency{
        return .init(base: self.base, rates: self.rates)
    }
}
