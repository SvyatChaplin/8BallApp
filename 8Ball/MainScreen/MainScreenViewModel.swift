//
//  MainScreenViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/28/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class MainScreenViewModel {

    var attemptToRequestAnAnswer: (() -> Void)?
    var didUpdateActivityState: ((Bool) -> Void)?
    var didUpdateAnswer: ((PresentableAnswer?, String?) -> Void)?
    var didReciveAnError: ((Error, String) -> Void)?
    var didUpdateCounter: ((String) -> Void)?
    var requestCounter: (() -> Void)?

    private let mainScreenModel: MainScreenModel

    init(mainScreenModel: MainScreenModel) {
        self.mainScreenModel = mainScreenModel
        setupBindings()
        setupCounter()
    }

    // Отправляем информацию о шейке
    func updateKeyChain() {
        mainScreenModel.updateCounter()
    }

    // Запрашиваем и получаем данные из KeyChain
    private func setupCounter() {
        requestCounter = { [weak self] in
            self?.mainScreenModel.showCount()
        }
        mainScreenModel.didUpdateCounter = { [weak self] count in
            self?.didUpdateCounter?(count)
        }
    }

    private func setupBindings() {
        // Обновляем состояние индикатора активности
        attemptToRequestAnAnswer = { [weak self] in
            self?.didUpdateActivityState?(true)
            self?.mainScreenModel.requestAnswer { [weak self] in
                self?.didUpdateActivityState?(false)
            }
        }
        // Обновляем ответ
        mainScreenModel.didUpdateAnswer = { [weak self] answer in
            if let answer = answer {
                self?.didUpdateAnswer?(PresentableAnswer(answer), nil)
            } else {
                self?.didUpdateAnswer?(nil, L10n.EmptyArrayWarning.message)
            }
        }
        // Обновляем счетчик
        mainScreenModel.didUpdateCounter = { [weak self] count in
            self?.didUpdateCounter?(count)
        }
        // Обрабатываем ошибки
        mainScreenModel.didReciveAnError = { [weak self] (error, errorText) in
            self?.didReciveAnError?(error, errorText)
        }

    }
}

// Приводим ответ к модели Presentable Answer и редактируем текст
extension PresentableAnswer {

    init(_ answer: Answer) {
        self.presentableAnswer = answer.magic.answer.uppercased()
    }

}
