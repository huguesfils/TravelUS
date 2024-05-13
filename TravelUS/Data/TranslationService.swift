//
//  TranslationService.swift
//  TravelUS
//
//  Created by Hugues Fils on 05/03/2024.
//

import Foundation

// Represents the response format expected from the translation API.
struct TranslationResponse: Codable {
    var data: TranslationData?
}

// Contains the translations part of the response.
struct TranslationData: Codable {
    var translations: [Translations]
}

// Represents a single translation in the response.
struct Translations: Codable {
    var translatedText: String // The translated text
}

// Provides functionality to perform translations using an external translation service.
class TranslationService {
    // Defines potential errors that could occur during translation requests.
    private enum TranslationError: Error {
        case noResponse // No response was received.
        case statusCodeIncorrect // The HTTP status code indicated an error.
        case noData // No data was returned in the response.
    }
    
    // The URL for the translation service API.
    private static let translationUrL = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    
    // The URLSession used for making HTTP requests.
    private let translationSession: URLSession
    
    // Initializes a new instance of the service, optionally allowing for a custom URLSession.
    init(translationSession: URLSession = URLSession(configuration: .default)) {
        self.translationSession = translationSession
    }
    
    // Performs a translation request and returns the result via a completion handler.
    func getTranslation(text: String, from: String, to: String, completionHandler : @escaping (TranslationResponse?, Error?) -> ()) {
        var request = URLRequest(url: TranslationService.translationUrL)
        request.httpMethod = "POST" // Sets the request method to POST.
        
        // Prepares the request body with necessary parameters.
        let body = "q=\(text)&target=\(to)&format=text&source=\(from)&key=\(APIKeys.translationApiKey)"
        request.httpBody = body.data(using: .utf8)
        
        // Starts the network request to fetch the translation.
        let task = translationSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async { // Ensures that the completion handler is called on the main thread.
                guard error == nil else {
                    completionHandler(nil, error) // Handles network errors.
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, TranslationError.noResponse) // Handles missing response.
                    return
                }
                
                guard response.statusCode == 200 else {
                    completionHandler(nil, TranslationError.statusCodeIncorrect) // Handles incorrect status codes.
                    print(response.statusCode)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, TranslationError.noData) // Handles missing data.
                    return
                }
                
                do {
                    // Attempts to decode the response data into the expected format.
                    let responseJSON = try JSONDecoder().decode(TranslationResponse.self, from: data)
                    completionHandler(responseJSON, error) // Returns the decoded data.
                } catch {
                    completionHandler(nil, error) // Handles JSON decoding errors.
                }
            }
        }
        task.resume() // Resumes the task if it was suspended.
    }
}
