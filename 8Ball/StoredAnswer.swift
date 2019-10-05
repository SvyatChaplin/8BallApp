//
//  StoredAnswer.swift
//  8Ball
//
//  Created by Svyat Chaplin on 10/3/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

struct StoredAnswer: Codable {

    let answer: String

}

extension StoredAnswer {

    init(answer: Answer) {
        self.answer = answer.magic.answer
    }

}
