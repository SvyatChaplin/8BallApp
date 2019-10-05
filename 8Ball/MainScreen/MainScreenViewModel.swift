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
    var didUpdateAnswer: ((String?) -> Void)?
    var didReciveAnError: ((Error) -> Void)?

    private let mainScreenModel: MainScreenModel

    init(mainScreenModel: MainScreenModel) {
        self.mainScreenModel = mainScreenModel
        setupBindings()
    }

    private func setupBindings() {
        attemptToRequestAnAnswer = { [weak self] in
            self?.didUpdateActivityState?(true)
            self?.mainScreenModel.requestAnswer { [weak self] in
                self?.didUpdateActivityState?(false)
            }
        }
        // Редактируем полученый ответ
        mainScreenModel.didUpdateAnswer = { [weak self] answer in
            if let answer = answer {
                self?.didUpdateAnswer?(answer.uppercased())
            } else {
                self?.didUpdateAnswer?(L10n.EmptyArrayWarning.message)
            }
        }
        mainScreenModel.didReciveAnError = { [weak self] error in
            self?.didReciveAnError?(error)
        }
    }
}
