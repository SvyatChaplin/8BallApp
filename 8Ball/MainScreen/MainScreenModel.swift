//
//  MainScreenModel1.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/30/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class MainScreenModel {

    var didUpdateAnswer: ((Answer?) -> Void)?
    var didReciveAnError: ((Error, String) -> Void)?
    var didUpdateCounter: ((String) -> Void)?

    private var answerProvider: AnswerPrivider
    private let networkingManager: NetworkingManager
    private var secureStorage: SecureStorage

    init(answerProvider: AnswerPrivider, networkingManager: NetworkingManager, secureStorage: SecureStorage) {
        self.answerProvider = answerProvider
        self.networkingManager = networkingManager
        self.secureStorage = secureStorage
    }

    // Получаем ответы из сервисов и обрабатываем ошибки
    func requestAnswer(_ completion: @escaping () -> Void) {
        if networkingManager.checkConnection() {
            networkingManager.fetchData { (data, error) in
                let answerAndError = self.networkingManager.decodingData(data: data, error: error)
                self.didUpdateAnswer?(answerAndError.answer)
                if let error = answerAndError.error {
                    self.didReciveAnError?(error, L10n.ConnectionError.message)
                }
                completion()
            }
        } else {
            let answerAndError = answerProvider.getAnswer()
            self.didUpdateAnswer?(answerAndError.answer)
            if let error = answerAndError.error {
                self.didReciveAnError?(error, L10n.EmptyArrayWarning.message)
            }
            completion()
        }
    }

    // Получаем количество шеков при загрузке приложения
    func showCount() {
        self.didUpdateCounter?(secureStorage.getCount())
    }

    // Обновляем показания счетчика и получаем новые показания
    func updateCounter() {
        secureStorage.updateCount()
        self.didUpdateCounter?(secureStorage.getCount())
    }

}
