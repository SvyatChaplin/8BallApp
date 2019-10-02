//
//  Networking.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/1/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import Alamofire

// В данном классе работаем с сетью
class NetworkingManagerService: NetworkingManager {

    // Проверяем соединение с сетью
    func checkConnection() -> Bool {
        let connectionStatus = NetworkReachabilityManager(host: L10n.urlString)?.isReachable
        return connectionStatus!
    }

    // Получаем данные из сети
    func getDataFromInternet(complitionHandler: @escaping (Data?, Error?) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: L10n.urlString) else { return }
        session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if data != nil {
                complitionHandler(data, nil)
                } else {
                    print(error!.localizedDescription)
                    complitionHandler(nil, error)
                }
            }
            }.resume()
    }

    // Расшифровуем данные при помощи модели и если возникают ошибки, то мы их ловим и выводим пользователю
    func decodingDataToString(data: Data) -> String {
            do {
                let decodedData = try JSONDecoder().decode(AnswerDecodingModel.self, from: data)
                let answerInString = decodedData.magic.answer
                return answerInString
            } catch {
                print(error.localizedDescription)
                return "\(error.localizedDescription) \(L10n.ConnectionError.message)"
            }
        }

    // Ловим ошибки, полученные при загрузке данных из сети
    func catchingDataErrors(error: Error?) -> String {
        print(error?.localizedDescription ?? L10n.ConnectionError.message)
        return "\(error?.localizedDescription ?? L10n.ConnectionError.message)"
    }

}
