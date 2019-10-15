//
//  AnswerModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 13.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import RealmSwift

class StoredAnswer: Object {
    @objc dynamic var answer: String?
    @objc dynamic var date = Date()

    convenience init(answer: Answer) {
        self.init()
        self.answer = answer.magic.answer
    }
}
