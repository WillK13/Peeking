//
//  APIClient.swift
//  Peeking
//
//  Created by Will kaminski on 7/31/24.
//

import Foundation

class APIClient {
    static let shared = APIClient()

    func performAnalysis(userId: String, userType: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://159.65.221.122/api/perform-analysis") else {  // Replace with your DigitalOcean server IP
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["user_id": userId, "user_type": userType]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in API request: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            guard httpResponse.statusCode == 200 else {
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response body: \(responseString ?? "No response body")")
                }
                print("HTTP response status code: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error"])))
                return
            }
            print("API call successful")
            completion(.success(()))
        }
        task.resume()
    }
}
