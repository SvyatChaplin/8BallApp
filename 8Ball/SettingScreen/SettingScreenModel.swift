//
//  SettingScreenModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/29/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class SettingScreenModel {

    private var answerProvider: AnswerPrivider

    init(answerProvider: AnswerPrivider) {
        self.answerProvider = answerProvider
    }

    // Добавляем новый ответ в хранилище
    func appendAnswer(_ answer: String) {
        answerProvider.answers.append(answer)
    }

    // Удаляем последний элемент хранилища если там есть хотя бы один элемент
    func removeLastAnswer() {
        if answerProvider.answers.isEmpty {
            answerProvider.answers.removeAll()
        } else {
            answerProvider.answers.removeLast()
        }
    }

    // Удаляем все содержимое хранилища
    func removeAllAnswers() {
        answerProvider.answers.removeAll()
    }

}
