//
//  Networking.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/30/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import Alamofire

class CheckConnection {
    // Проверяем соединение с сервером
    func checkConnectionFunc() -> Bool {
        let connectionStatus = NetworkReachabilityManager(host: "https://8ball.delegator.com/magic/JSON/question")?.isReachable
        return connectionStatus!
    }
    
}

