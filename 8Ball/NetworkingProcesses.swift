//
//  NetworkingProcesses.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/29/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingProcess {
    
    let session = URLSession.shared
    
    let url = URL(string: "https://8ball.delegator.com/magic/JSON/question")!
    
    func checkInternet() -> Bool {
        let connectionStatus = NetworkReachabilityManager(host: "https://8ball.delegator.com/magic/JSON/question")?.isReachable
        return connectionStatus!
    }
    
    func getAnswerFromInternet(completionHandler: @escaping (Data?) -> Void) {
        guard checkInternet() else { return }
        session.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }.resume()
    }
    
}
