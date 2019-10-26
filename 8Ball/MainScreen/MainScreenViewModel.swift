//
//  MainScreenViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/28/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RxSwift

class MainScreenViewModel {

    let didUpdateAnswer = BehaviorSubject<(PresentableAnswer?, String?)>(value: (nil, nil))
    let didReciveAnError = BehaviorSubject<(Error?, String)>(
        value: (nil, L10n.ConnectionError.message))
    let shakeAction = PublishSubject<Void>()
    let requestCounter = PublishSubject<Void>()
    let didUpdateCounter = BehaviorSubject<String>(value: "0")
    let loadingState = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()

    private let mainScreenModel: MainScreenModel

    init(mainScreenModel: MainScreenModel) {
        self.mainScreenModel = mainScreenModel
        setupRxBindings()
    }

    private func setupRxBindings() {
        requestCounter.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mainScreenModel.requestCounter.onNext(())
        }).disposed(by: disposeBag)

        shakeAction.subscribe { [weak self] (_) in
            guard let self = self else { return }
            self.mainScreenModel.shakeAction.onNext(())
        }.disposed(by: disposeBag)

        mainScreenModel.loadingState.subscribe(onNext: { [weak self] (state) in
            guard let self = self else { return }
            self.loadingState.onNext(state)
        }).disposed(by: disposeBag)

        mainScreenModel.didUpdateAnswer.subscribe(onNext: { [weak self] (answer) in
            guard let self = self else { return }
            if let answer = answer {
                self.didUpdateAnswer.onNext((PresentableAnswer(answer), nil))
            } else {
                self.didUpdateAnswer.onNext((nil, L10n.EmptyArrayWarning.message))
            }
        }).disposed(by: disposeBag)

        mainScreenModel.didUpdateCounter.subscribe(onNext: { [weak self] (count) in
            guard let self = self else { return }
            self.didUpdateCounter.onNext(L10n.counter + String(count))
        }).disposed(by: disposeBag)

        mainScreenModel.didReciveAnError.subscribe(onNext: { [weak self] (error, errorText) in
            guard let self = self else { return }
            self.didReciveAnError.onNext((error, errorText))
        }).disposed(by: disposeBag)
    }
}

// Приводим ответ к модели Presentable Answer и редактируем текст
extension PresentableAnswer {

    init(_ answer: Answer) {
        self.text = answer.magic.answer.uppercased()
    }

}
