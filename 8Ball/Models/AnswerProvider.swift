//
//  UserArray.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/27/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

// Сохраняем дефолтные и пользовательские ответы на устройстве
class AnswerProvider {
var answers: [String] {
    get {
        return UserDefaults.standard.array(forKey: "arrayOfAnswers") as? [String] ?? ["Yes",
                                                                                      "No",
                                                                                      "Why not?"]
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "arrayOfAnswers")
    }
}
}
