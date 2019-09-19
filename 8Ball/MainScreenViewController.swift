//
//  MainScreen.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/23/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import UIKit
import Alamofire

class MainScreenViewController: UIViewController {

    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // Создаем экземпляры необходимых классов
    private let networkingManager = NetworkingManager()
    private var userOrDefaultAnswers = AnswerProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        answerLabel.text = "Ask your qestion and shake your IPhone to see the answer"
    }
    
    // Функция запуска индикатора активности
    private func startAnimatingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    // Функция остановки индикатора активности
    private func stopAnimatingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // Получаем данные из сети и обрабатываем ошибки
    private func getRemoteAnswer() {
        answerLabel.text = ""
        startAnimatingIndicator()
        networkingManager.getDataFromInternet { (data, error) in
            if data != nil {
                self.answerLabel.text = self.networkingManager.decodingDataToString(data: data!)
                self.stopAnimatingIndicator()
            } else {
                self.networkingManager.catchingDataErrors(error: error)
                let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "Something went wrong")", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.stopAnimatingIndicator()
                self.answerLabel.text = "Please turn off your internet connection to use default answers"
            }
        }
    }
    
    // Получаем дефолтный/пользовательский ответ
    private func getLocalAnswer() {
        if userOrDefaultAnswers.answers.isEmpty {
            let alert = UIAlertController(title: "Ooops", message: "Please add your answers at the setting screen!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.answerLabel.text = "Please add your answers at the setting screen!"
        } else {
            self.answerLabel.text = userOrDefaultAnswers.answers.randomElement()
        }
    }
    
    // По "встряхиванию" проверяем событие на "шейк", проверяем соединение с сетью и либо выводим ответ из сети, либо выводим дефолтные/пользовательские ответы
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        if networkingManager.checkConnection() {
            getRemoteAnswer()
        } else {
            getLocalAnswer()
        }
    }
}
