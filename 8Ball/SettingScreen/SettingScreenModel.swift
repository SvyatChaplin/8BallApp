//
//  SettingScreenModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/29/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class SettingScreenModel {

    private var answerProvider: AnswerProvider

    init(answerProvider: AnswerProvider) {
        self.answerProvider = answerProvider
    }

    var localAnswers: [String]?

    private func appendAnswer(_ completion: @escaping () -> Void) {
    }

}
