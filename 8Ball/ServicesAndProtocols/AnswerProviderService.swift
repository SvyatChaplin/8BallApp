//
//  UserArray.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/27/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class AnswerProviderService: AnswerPrivider {

    // Храним ответы в UserDefaults
    private var dataArray: [Data] = UserDefaults.standard.array(forKey:
        L10n.key) as? [Data] ?? []

    // Сохраняем пользовательский ответ преобразовывая его в формат Data
    func save(answer: Answer) {
        let storedAnswer = StoredAnswer(answer: answer)
        guard let data = try? JSONEncoder().encode(storedAnswer) else { return }
        dataArray.append(data)
        UserDefaults.standard.setValue(dataArray, forKey: L10n.key)
    }

    // Получаем ответ из хранилища и обрабатываем ошибки
    func getAnswer() -> (answer: Answer?, error: Error?) {
        if let data = dataArray.randomElement(),
            let decodedData = try? JSONDecoder().decode(StoredAnswer.self, from: data) {
            return (Answer(answer: decodedData), nil)
        } else {
            let error = L10n.EmptyArrayWarning.message as? Error
            return (nil, error)
        }
    }

    // Удаляем все ответы
    func removeAll() {
        dataArray.removeAll()
        UserDefaults.standard.setValue(dataArray, forKey: L10n.key)
    }

    // Удаляем последний ответ
    func removeLast() {
        if dataArray.isEmpty {
            dataArray.removeAll()
            UserDefaults.standard.setValue(dataArray, forKey: L10n.key)
        } else {
            dataArray.removeLast()
            UserDefaults.standard.setValue(dataArray, forKey: L10n.key)
        }
    }
}

extension Answer {

    init(answer: StoredAnswer) {
        magic = Magic(answer: answer.answer)
    }

}
