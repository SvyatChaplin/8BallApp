//
//  HistoryViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RxSwift

class HistoryViewModel {

    let sendIndexToRemoveAnswer = PublishSubject<Int>()
    let sendNewAnswer = PublishSubject<String>()

    let tryToRemoveAllAnswers = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    private let historyModel: HistoryModel

    init(historyModel: HistoryModel) {
        self.historyModel = historyModel
        setupRxBindings()
    }

    private func setupRxBindings() {
        tryToRemoveAllAnswers
            .bind(to: historyModel.tryToRemoveAllAnswers)
            .disposed(by: disposeBag)

        sendIndexToRemoveAnswer
            .bind { [weak self] (index) in
                guard let self = self else { return }
                let answer = self.historyModel.getObjects()[index]
                self.historyModel.sendAnswerToRemove.onNext(answer)
        }
        .disposed(by: disposeBag)

        sendNewAnswer
            .map { Answer(magic: Magic(answer: $0, date: Date())) }
            .bind(to: self.historyModel.sendNewAnswer)
            .disposed(by: disposeBag)
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

}
