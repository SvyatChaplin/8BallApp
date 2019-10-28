//
//  MainScreenModel1.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/30/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RxSwift

class MainScreenModel {

    let didUpdateAnswer = PublishSubject<Answer>()
    let didReceiveAnError = BehaviorSubject<(error: Error?, errorText: String)>(
        value: (nil, L10n.ConnectionError.message))
    let didUpdateCounter = BehaviorSubject<Int>(value: 0)
    let loadingState = BehaviorSubject<Bool>(value: false)

    let shakeAction = PublishSubject<Void>()
    let requestCounter = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    private var storageManager: StorageManager
    private let networkingManager: NetworkingManager
    private var secureStorage: SecureStorage

    init(storageManager: StorageManager, networkingManager: NetworkingManager, secureStorage: SecureStorage) {
        self.storageManager = storageManager
        self.networkingManager = networkingManager
        self.secureStorage = secureStorage
        setupRxBindings()
    }

    private func setupRxBindings() {
        requestCounter
            .subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.didUpdateCounter.onNext(self.secureStorage.getCountInt())
            })
            .disposed(by: disposeBag)

        shakeAction
            .subscribe { [weak self] (_) in
            guard let self = self else { return }
            self.loadingState.onNext(true)
            self.requestAnswer {
                self.loadingState.onNext(false)
            }
            self.updateCounts()
            self.didUpdateCounter.onNext(self.secureStorage.getCountInt())
        }
        .disposed(by: disposeBag)
    }

    // Получаем ответы из сервисов и обрабатываем ошибки
    func requestAnswer(_ completion: @escaping () -> Void) {
        if networkingManager.checkConnection() {
            networkingManager.fetchData { [weak self] (data, error) in
                guard let self = self else { return }
                let answerAndError = self.networkingManager.decodingData(data: data, error: error)
                if let answer = answerAndError.answer {
                    self.didUpdateAnswer.onNext(answer)
                    self.storageManager.saveObject(answer)
                }
                if let error = answerAndError.error {
                    self.didReceiveAnError.onNext((error, L10n.ConnectionError.message))
                }
                completion()
            }
        } else {
            let answer = storageManager.getRandomElement()
            if let answer = answer {
                self.didUpdateAnswer.onNext(answer)
            } else {
                self.didReceiveAnError.onNext((nil, L10n.EmptyArrayWarning.message))
            }
            completion()
        }
    }

    // Обновляем показания счетчика и получаем новые показания
    func updateCounts() {
        var count = secureStorage.getCountInt()
        count += 1
        secureStorage.updateCounts(count)
    }

}
