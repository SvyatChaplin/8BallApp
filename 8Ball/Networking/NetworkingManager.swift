//
//  Networking.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/1/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager {
    
    
    func checkConnectionFunc() -> Bool {
        let connectionStatus = NetworkReachabilityManager(host: "https://8ball.delegator.com/magic/JSON/question")?.isReachable
        return connectionStatus!
    }
    
    // Получаем данные из сети
    func getDataFromInternet(complitionHandler: @escaping (Data) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://8ball.delegator.com/magic/JSON/question")!
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                complitionHandler(data!)
            }
        }.resume()
    }
    
    // Расшифровуем данные при помощи модели
    func prepareDataToUse(data: Data?) -> String {
        let internetDict = try? JSONDecoder().decode(AnswerModel.self, from: data!)
        let answerReadyToUse = internetDict?.magic.answer
        return answerReadyToUse!
    }
    
}
