//
//  CurrencyService.swift
//  TravelUS
//
//  Created by Hugues Fils on 07/03/2024.
//

import Foundation

// Defines a struct to model the response from a currency API.
// It is Codable to easily decode from JSON data.
struct CurrencyResponse: Codable {
    var base: String // The base currency for the rates provided
    var rates: [String: Double] // A dictionary of currency rates with the key as the currency code and the value as the rate
}

// Defines a service for fetching currency data.
class CurrencyService {
    // Enumerates the potential errors that could occur within the service.
    private enum CurrencyError: Error {
        case noResponse // No response from the server
        case statusCodeIncorrect // The HTTP status code is not 200 OK
        case noData // No data was returned from the server
    }
   
    // The URL for fetching currency data, including an API key.
    private static let currencyUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(APIKeys.currencyApiKey)")!
    
    // The URLSession used for making HTTP requests.
    private let currencySession: URLSession
    
    // Initializes a new instance of the service, optionally allowing for a custom URLSession.
    // Default URLSession configuration is used if none is provided.
    init(currencySession: URLSession = URLSession(configuration: .default)) {
        self.currencySession = currencySession
    }
    
    // A reference to the current URLSessionDataTask, if one is in progress.
    private var task: URLSessionDataTask?
    
    // Fetches the current currency rates and returns them via a completion handler.
    // If an error occurs, the error parameter of the completion handler will be non-nil.
    func getCurrency(completionHandler: @escaping (CurrencyResponse?, Error?) -> Void) {
        var request = URLRequest(url: CurrencyService.currencyUrl)
        request.httpMethod = "GET" // Sets the HTTP method of the request to GET
        
        task?.cancel() // Cancels any existing task before starting a new one
        task = currencySession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async { // Ensures the completion handler is called on the main thread
                guard error == nil else { // Checks for an error in the network response
                    completionHandler(nil, error)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // Checks the HTTP status code
                    completionHandler(nil, CurrencyError.statusCodeIncorrect)
                    return
                }
                guard let data = data else { // Checks that data was received
                    completionHandler(nil, CurrencyError.noData)
                    return
                }
                do {
                    // Attempts to decode the JSON response into the CurrencyResponse struct
                    let responseJSON = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                    completionHandler(responseJSON, nil) // Calls the completion handler with the decoded data
                } catch {
                    completionHandler(nil, error) // Calls the completion handler with an error if decoding fails
                }
            }
        }
        task?.resume() // Starts the network request
    }
}
