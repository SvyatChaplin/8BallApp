//
//  MainScreenModel1.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/30/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import Alamofire

class MainScreenModel {

    var didUpdateAnswer: ((String?) -> Void)?

    var answerProvider: AnswerProvider
    let networkingManager: NetworkingManager

    init(answerProvider: AnswerProvider, networkingManager: NetworkingManager) {
        self.answerProvider = answerProvider
        self.networkingManager = networkingManager
    }

    // Храним полученный ответ в переменной
    var answerText: String? {
        didSet {
            didUpdateAnswer?(answerText)
        }
    }

    private func getRemoteAnswer(_ completion: @escaping () -> Void) {
        networkingManager.getDataFromInternet { (data, error) in
            if data != nil {
                self.answerText = self.networkingManager.decodingDataToString(data: data!)
            } else {
                self.networkingManager.catchingDataErrors(error: error)
            }
            completion()
        }
    }

    private func getLocalAnswer(_ completion: @escaping () -> Void) {
        if answerProvider.answers.isEmpty {
            self.answerText = L10n.EmptyArrayWarning.message
        } else {
            self.answerText = answerProvider.answers.randomElement()
        }
    }

    func requestAnswer(_ completion: @escaping () -> Void) {
        if networkingManager.checkConnection() {
            getRemoteAnswer(completion)
        } else {
            getLocalAnswer(completion)
        }
    }

}
