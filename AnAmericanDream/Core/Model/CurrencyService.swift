//
//  CurrencyService.swift
//  AnAmericanDream
//
//  Created by Hugues Fils on 07/03/2024.
//

import Foundation

struct CurrencyResponse: Codable {
    var base: String
    var rates: [String: Double]
}

class CurrencyService {
    private enum CurrencyError: Error {
        case noResponse
        case statusCodeIncorrect
        case noData
    }
   
    private static let currencyUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(APIKeys.currencyApiKey)")!
    
    private let currencySession: URLSession
    
    init(currencySession: URLSession = URLSession(configuration: .default)) {
        self.currencySession = currencySession
    }
    
    private var task: URLSessionDataTask?
    func getCurrency(completionHandler: @escaping (CurrencyResponse?, Error?) -> Void) {
        var request = URLRequest(url: CurrencyService.currencyUrl)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = currencySession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil, CurrencyError.statusCodeIncorrect)
                    return
                }
                guard let data = data else {
                    completionHandler(nil, CurrencyError.noData)
                    return
                }
                do {
                    let responseJSON = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                    completionHandler(responseJSON, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        task?.resume()
    }
}
