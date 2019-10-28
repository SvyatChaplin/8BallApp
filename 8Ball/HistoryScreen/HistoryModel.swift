//
//  HistoryModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RxSwift

class HistoryModel {

    let sendAnswerToRemove = PublishSubject<Answer>()
    let sendNewAnswer = PublishSubject<Answer>()

    let tryToRemoveAllAnswers = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    private var storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
        setupRxBindings()
    }

    private func setupRxBindings() {
        tryToRemoveAllAnswers
            .bind { [weak self] (_) in
                guard let self = self else { return }
                self.storageManager.deleteAllObjects()
        }
        .disposed(by: disposeBag)

        sendAnswerToRemove
            .bind { [weak self] (answer) in
                guard let self = self else { return }
                self.storageManager.deleteObject(answer)
        }
        .disposed(by: disposeBag)

        sendNewAnswer
            .bind { [weak self] (answer) in
                guard let self = self else { return }
                self.storageManager.saveObject(answer)
        }
        .disposed(by: disposeBag)
    }

    func getObjects() -> [Answer] {
        return storageManager.getObjects()
    }

    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void) {
        storageManager.observeAnswerList(callback)
    }

}
