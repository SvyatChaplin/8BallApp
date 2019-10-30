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

    let sendIndexToRemoveAnswer = PublishSubject<Int>()
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
            .subscribe(onNext: { [weak self] _ in
                self?.storageManager.deleteAllObjects()
            })
            .disposed(by: disposeBag)

        sendIndexToRemoveAnswer
            .subscribe(onNext: { [weak self] (index) in
                self?.storageManager.deleteObject(at: index)
            })
            .disposed(by: disposeBag)

        sendNewAnswer
            .subscribe(onNext: { [weak self] (answer) in
                self?.storageManager.saveObject(answer)
            })
            .disposed(by: disposeBag)
    }

    func getObjects() -> [Answer] {
        return storageManager.getObjects()
    }

    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void) {
        storageManager.observeAnswerList(callback)
    }

}
