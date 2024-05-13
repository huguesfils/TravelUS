//
//  FetchCurrencyUseCase.swift
//  TravelUS
//
//  Created by Hugues Fils on 13/05/2024.
//

import Foundation

protocol FetchCurrencyUseCase {
    func execute() async -> Result<Currency, DomainError>
}

struct DefaultFetchCurrencyUseCase: FetchCurrencyUseCase {
    
    let repository: CurrencyRepository
    
    func execute() async -> Result<Currency, DomainError> {
        return await repository.getCurrency()
    }
}
