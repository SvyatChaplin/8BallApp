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
    var didUpdateCounter: ((Int) -> Void)?

    private var storageManager: StorageManager
    private let networkingManager: NetworkingManager
    private var secureStorage: SecureStorage

    init(storageManager: StorageManager, networkingManager: NetworkingManager, secureStorage: SecureStorage) {
        self.storageManager = storageManager
        self.networkingManager = networkingManager
        self.secureStorage = secureStorage
    }

    // Получаем ответы из сервисов и обрабатываем ошибки
    func requestAnswer(_ completion: @escaping () -> Void) {
        if networkingManager.checkConnection() {
            networkingManager.fetchData { (data, error) in
                let answerAndError = self.networkingManager.decodingData(data: data, error: error)
                self.didUpdateAnswer?(answerAndError.answer)
                if let answer = answerAndError.answer {
                    self.storageManager.saveObject(answer)
                }
                if let error = answerAndError.error {
                    self.didReciveAnError?(error, L10n.ConnectionError.message)
                }
                completion()
            }
        } else {
            let answerAndError = storageManager.getRandomElement()
            self.didUpdateAnswer?(answerAndError.answer)
            if let error = answerAndError.error {
                self.didReciveAnError?(error, L10n.EmptyArrayWarning.message)
            }
            completion()
        }
    }

    // Получаем количество шеков при загрузке приложения
    func getCount() {
        self.didUpdateCounter?(secureStorage.getCountInt())
    }

    // Обновляем показания счетчика и получаем новые показания
    func updateCounts() {
        var count = secureStorage.getCountInt()
        count += 1
        secureStorage.updateCounts(count)
        self.didUpdateCounter?(secureStorage.getCountInt())
    }

}
