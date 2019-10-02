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

var answers: [String] {
    get {
        return UserDefaults.standard.array(forKey: L10n.key) as? [String] ?? [L10n.Answer.one,
                                                                              L10n.Answer.two,
                                                                              L10n.Answer.three]
    }
    set {
        UserDefaults.standard.set(newValue, forKey: L10n.key)
    }
}
}
