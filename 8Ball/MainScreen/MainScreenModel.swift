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
    var didReciveAnError: ((Error) -> Void)?

    // Храним полученный ответ в переменной
    private var answerText: String? {
        didSet {
            didUpdateAnswer?(answerText)
        }
    }

    private var answerProvider: AnswerPrivider
    private let networkingManager: NetworkingManager

    init(answerProvider: AnswerPrivider, networkingManager: NetworkingManager) {
        self.answerProvider = answerProvider
        self.networkingManager = networkingManager
    }

    // Получаем ответы из сервисов и обрабатываем ошибки
    func requestAnswer(_ completion: @escaping () -> Void) {
        if networkingManager.checkConnection() {
            networkingManager.fetchData { (data, error) in
                let answerAndError = self.networkingManager.decodingData(data: data, error: error)
                self.answerText = answerAndError.answer
                if let error = answerAndError.error {
                    self.didReciveAnError?(error)
                }
                completion()
            }
        } else {
            self.answerText = answerProvider.answers.randomElement()
            completion()
        }
    }

}
