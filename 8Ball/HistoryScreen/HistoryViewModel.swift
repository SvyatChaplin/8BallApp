//
//  HistoryViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class HistoryViewModel {

    private let historyModel: HistoryModel

    init(historyModel: HistoryModel) {
        self.historyModel = historyModel
    }

    func getObjects() -> [PresentableAnswer] {
        let answers = historyModel.getObjects()
        return answers.map(PresentableAnswer.init)
    }

    func getAnswer(at index: Int) -> PresentableAnswer {
        let answers = historyModel.getObjects()
        let answer = answers[index]
        return PresentableAnswer(answer)
    }

    func removeAnswer(at index: Int) {
        let answer = historyModel.getObjects()[index]
        historyModel.deleteObject(answer)
    }

    func numberOfAnswers() -> Int {
        return historyModel.getObjects().count
    }

    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void) {
        historyModel.observeAnswerList(callback)
    }

}
