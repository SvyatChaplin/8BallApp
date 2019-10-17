//
//  SettingScreenViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/28/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class SettingScreenViewModel {

    private let settingScreenModel: SettingScreenModel

    init(settingScreenModel: SettingScreenModel) {
        self.settingScreenModel = settingScreenModel
    }

    // Отправляем новый ответ в Model преобразовав его в новый тип данных
    func sendNewAnswer(_ answer: String) {
        settingScreenModel.appendAnswer(Answer(magic: Magic(answer: answer, date: Date())))
    }

    // Обращаемся к Model и просим удалить все ответы
    func removeAllAnswers() {
        settingScreenModel.removeAllAnswers()
    }

    func getObjects() -> [PresentableAnswer] {
        let answers = settingScreenModel.getObjects()
        return answers.map(PresentableAnswer.init)
    }

}
