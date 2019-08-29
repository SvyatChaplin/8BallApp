//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit
import Alamofire

class MainScreen: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    
    let networkingProcess = NetworkingProcess()
    let decodingProcess = DecodingProcess()
    let answerReadyToUse = AnswersReadyToUse()
    

    // При загрузке приложения ярлык отображает текст с инструкциями
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerLabel.text = "Ask your qestion and shake your IPhone to see the answer"
    }
    

    
    
    
    // Функция, в которой мы отправляем запрос на сервер, получаем данные в формате JSON и расшифровуем их (добавляем в словарь)
    
//    func getData() {
//
//        let session = URLSession.shared
//
//        let url = URL(string: "https://8ball.delegator.com/magic/JSON/question")!
//
//        session.dataTask(with: url) { data, _, _ in
//
//            let dict = try! JSONDecoder().decode([String: [String: String]].self, from: data!)
//
//            DispatchQueue.main.async { self.answerLabel.text = dict["magic"]!["answer"]! }
//
//            }.resume()
//    }
    
    // В начале встряхиваня устройства показываем, что мы начинаем искать ответ. Далее проверяем наше соединение с сетью. Если сервер с ответами доступен, то направляемся по ветке if, где вызывется функция getData(). Если связи с сервером нет, то идем по ветке else, где у нас подтягиваются дефолтные ответы и ответы пользователей (также фильтруем массив на наличие пустых строк).
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        answerLabel.text = "Looking for an answer"
        
        if networkingProcess.checkInternet() {
            answerReadyToUse.readyAnswer { (answer) in
                self.answerLabel.text = answer
            }
        } else {
            userArray = userArray.filter(){ $0 != "" }
            self.answerLabel.text = userArray.randomElement()
            print(userArray)
        }
        
        
//        let connectionStatus = NetworkReachabilityManager(host: "https://8ball.delegator.com/magic/JSON/question")?.isReachable
//        if connectionStatus! {
//            getData()
//        } else {
//            userArray = userArray.filter(){ $0 != "" }
//            self.answerLabel.text = userArray.randomElement()
//            print(userArray)
//        }
    }
    
}


