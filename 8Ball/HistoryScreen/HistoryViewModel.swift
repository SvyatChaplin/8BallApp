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
        var presentableAnswerArray: [PresentableAnswer] = []
        for item in answers {
           let presentableAnswer = PresentableAnswer(item)
            presentableAnswerArray.append(presentableAnswer)
        }
        return presentableAnswerArray
    }

}
