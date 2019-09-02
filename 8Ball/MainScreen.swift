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
    
    // Создаем экземпляры необходимых классов
    let checkConnection = CheckConnection()
    let networking = Networking()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerLabel.text = "Ask your qestion and shake your IPhone to see the answer"
    }
    
    
    // По "встряхиванию" проверяем соединение с сетью и либо выводим ответ из сети, либо выводим дефолтные/пользовательские ответы
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        answerLabel.text = "Looking for an answer"
        
        if checkConnection.checkConnectionFunc() {
            networking.getDataFromInternet { (data) in
                self.answerLabel.text = self.networking.prepareDataToUse(data: data)
            }
        } else {
            userArray = userArray.filter(){ $0 != "" }
            self.answerLabel.text = userArray.randomElement()
        }
    }
    
}


