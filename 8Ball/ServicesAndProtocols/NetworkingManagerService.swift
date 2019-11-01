//
//  Networking.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/1/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManagerService: NetworkingManager {

    // Check internet connection
    func checkConnection() -> Bool {
        let connectionStatus = NetworkReachabilityManager(host: L10n.urlString)?.isReachable
        return connectionStatus!
    }

    // Geting data from internet
    func fetchData(complitionHandler: @escaping (Data?, Error?) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: L10n.urlString) else { return }
        session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let data = data {
                    complitionHandler(data, nil)
                } else {
                    complitionHandler(nil, error)
                }
            }
        }.resume()
    }

    // Decoding data and catch errors
    func decodingData(data: Data?, error: Error?) -> (answer: Answer?, error: Error?) {
        if let data = data {
            do {
                let decodedData = try JSONDecoder().decode(Answer.self, from: data)
                return (decodedData, nil)
            } catch {
                print(error.localizedDescription)
                return (nil, error)
            }
        } else {
            print(error?.localizedDescription ?? L10n.ConnectionError.message)
            return (nil, error)
        }
    }

}
