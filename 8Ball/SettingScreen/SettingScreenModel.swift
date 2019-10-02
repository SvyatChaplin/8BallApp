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

    // Принимаем ответ и вызываем необходимый метод
    var newAnswer: String? {
        didSet {
            appendAnswer()
        }
    }

    // Добавляем ответ в хранилище
    private func appendAnswer() {
        answerProvider.answers.append(newAnswer!)
    }

    // Удаляем последний элемент хранилища если там есть хотя бы один элемент
    func removeLastAnswer() {
        if answerProvider.answers.count > 1 {
            answerProvider.answers.removeLast()
        } else {
            answerProvider.answers.removeAll()
        }
    }

    // Удаляем все содержимое хранилища
    func removeAllAnswers() {
        answerProvider.answers.removeAll()
    }

}
