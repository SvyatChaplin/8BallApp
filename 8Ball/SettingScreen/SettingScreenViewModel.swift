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

    // Принимаем новый ответ и передаем его в Model
    var newAnswer: String? {
        didSet {
            self.settingScreenModel.newAnswer = self.newAnswer
        }
    }

    // Обращаемся к Model и просим удалить последний ответ
    func removeLastAnswer() {
        settingScreenModel.removeLastAnswer()
    }

    // Обращаемся к Model и просим удалить все ответы
    func removeAllAnswers() {
        settingScreenModel.removeAllAnswers()
    }

}
