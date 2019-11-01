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
    let didReceiveAnError = PublishSubject<(error: Error?, errorText: String)>()
    let didUpdateCounter = PublishSubject<Int>()
    let loadingState = PublishSubject<Bool>()

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
            .withLatestFrom(Observable.just(secureStorage.getCountInt()))
            .bind(to: didUpdateCounter)
            .disposed(by: disposeBag)

        shakeAction
            .subscribe { [weak self] _ in
                self?.getAllData()
        }
        .disposed(by: disposeBag)
    }

    private func getAllData() {
        loadingState.onNext(true)
        requestAnswer { [weak self] in
            self?.loadingState.onNext(false)
        }
        updateCounts()
        didUpdateCounter.onNext(secureStorage.getCountInt())
    }

    // Get data from services
    private func requestAnswer(_ completion: @escaping () -> Void) {
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

    // Increase counter data
    private func updateCounts() {
        var count = secureStorage.getCountInt()
        count += 1
        secureStorage.updateCounts(count)
    }

}
