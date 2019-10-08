//
//  AnswerProvider.swift
//  8Ball
//
//  Created by Svyat Chaplin on 10/2/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

protocol AnswerPrivider {

    func saveAnswer(answer: Answer)
    func getAnswer() -> (answer: Answer?, error: Error?)
    func removeLast()
    func removeAll()

}
