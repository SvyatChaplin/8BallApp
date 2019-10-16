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

    func deleteObject(_ answer: PresentableAnswer) {
        historyModel.deleteObject(Answer(magic: Magic(answer: answer.presentableAnswer, date: answer.date)))
    }

}
