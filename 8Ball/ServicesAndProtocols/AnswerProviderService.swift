//
//  UserArray.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/27/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

// Сохраняем дефолтные и пользовательские ответы на устройстве
class AnswerProviderService: AnswerPrivider {

    var answerArray: [Data] = UserDefaults.standard.array(forKey: L10n.key) as? [Data] ?? []

    func save(answer: Answer) {
        let storedAnswer = StoredAnswer(answer: answer)
        guard let data = try? JSONEncoder().encode(storedAnswer) else { return }
        answerArray.append(data)
        print(answerArray)
        UserDefaults.standard.setValue(answerArray, forKey: L10n.key)
    }

    func getAnswer() -> (answer: Answer?, error: Error?) {
        if let data = answerArray.randomElement() {
                let decodedData = try? JSONDecoder().decode(Answer.self, from: data)
                return (decodedData, nil)
            } else {
                let error = L10n.EmptyArrayWarning.message as? Error
                return (nil, error)
            }
        }

}
