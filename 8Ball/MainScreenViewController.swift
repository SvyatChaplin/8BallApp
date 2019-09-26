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
    @IBOutlet weak var imageView: UIImageView!

    // Создаем экземпляры необходимых классов
    private let networkingManager = NetworkingManager()
    private var answerProvider = AnswerProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        answerLabel.text = L10n.wellcomeText
        // Присваиваю изображени аутлету через СвифтГен
        imageView.image = Asset._8ballcut.image
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
        answerLabel.text?.removeAll()
        startAnimatingIndicator()
        networkingManager.getDataFromInternet { (data, error) in
            if data != nil {
                self.answerLabel.text = self.networkingManager.decodingDataToString(data: data!)
                self.stopAnimatingIndicator()
            } else {
                self.networkingManager.catchingDataErrors(error: error)
                let alert = UIAlertController(title: L10n.ConnectionError.title,
                                             message: "\(error?.localizedDescription ?? L10n.ConnectionError.message)",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.stopAnimatingIndicator()
                self.answerLabel.text = L10n.ConnectionError.message
            }
        }
    }

    // Получаем дефолтный/пользовательский ответ
    private func getLocalAnswer() {
        if answerProvider.answers.isEmpty {
            let alert = UIAlertController(title: L10n.EmptyArrayWarning.title,
                                          message: L10n.EmptyArrayWarning.message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: L10n.Button.ok, style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.answerLabel.text = L10n.EmptyArrayWarning.message
        } else {
            self.answerLabel.text = answerProvider.answers.randomElement()
        }
    }

    // По "встряхиванию" проверяем событие на "шейк", проверяем соединение с сетью и либо
    // выводим ответ из сети, либо выводим дефолтные/пользовательские ответы
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        if networkingManager.checkConnection() {
            getRemoteAnswer()
        } else {
            getLocalAnswer()
        }
    }
}
