//
//  MainScreenModel1.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/30/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class MainScreenModel {

    var didUpdateAnswer: ((String?) -> Void)?

    private var answerProvider: AnswerPrivider
    private let networkingManager: NetworkingManager

    init(answerProvider: AnswerPrivider, networkingManager: NetworkingManager) {
        self.answerProvider = answerProvider
        self.networkingManager = networkingManager
    }

    // Храним полученный ответ в переменной
    var answerText: String? {
        didSet {
            didUpdateAnswer?(answerText)
        }
    }

    // Загружаем данные из сети и обрабатываем ошибки
    private func getRemoteAnswer(_ completion: @escaping () -> Void) {
        networkingManager.getDataFromInternet { (data, error) in
            if data != nil {
                self.answerText = self.networkingManager.decodingDataToString(data: data!)
            } else {
                self.answerText = self.networkingManager.catchingDataErrors(error: error)
            }
            completion()
        }
    }

    // Загружаем данные из хранилища или сообщаем об ошибке
    private func getLocalAnswer(_ completion: @escaping () -> Void) {
        if answerProvider.answers.isEmpty {
            self.answerText = L10n.EmptyArrayWarning.message
        } else {
            self.answerText = answerProvider.answers.randomElement()
        }
        completion()
    }

    // Проверяем соединение с сетью и выдаем соответствующий ответ
    func requestAnswer(_ completion: @escaping () -> Void) {
        if networkingManager.checkConnection() {
            getRemoteAnswer(completion)
        } else {
            getLocalAnswer(completion)
        }
    }

}
