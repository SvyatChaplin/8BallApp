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

    private var answerText: Answer? {
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
                    self.didReciveAnError?(error, L10n.ConnectionError.message)
                }
                completion()
            }
        } else {
            let answerAndError = answerProvider.getAnswer()
            self.answerText = answerAndError.answer
            if let error = answerAndError.error {
                self.didReciveAnError?(error, L10n.EmptyArrayWarning.message)
            }
            completion()
        }
    }

}
