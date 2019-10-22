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

    func observeAnswerList(_ callback: @escaping (CollectionChange<[PresentableAnswer]>) -> Void) {
        historyModel.observeAnswerList { changes in
            switch changes {
            case .initial(let list):
                callback(.initial(list.map(PresentableAnswer.init)))
            case .update(let list, let deletions, let insertions, let modifications):
                callback(.update(list.map(PresentableAnswer.init), deletions, insertions, modifications))
            case .error(let error):
                callback(.error(error))
            }
        }
    }

    func removeAllAnswers() {
        historyModel.removeAllAnswers()
    }

    func sendNewAnswer(_ answer: String) {
        historyModel.appendAnswer(Answer(magic: Magic(answer: answer, date: Date())))
    }

}
