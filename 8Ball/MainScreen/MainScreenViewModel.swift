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

    let didUpdateAnswer = PublishSubject<PresentableAnswer>()
    let didReceiveAnError = PublishSubject<(error: Error?, errorText: String)>()
    let didUpdateCounter = PublishSubject<String>()
    let loadingState = PublishSubject<Bool>()

    let shakeAction = PublishSubject<Void>()
    let requestCounter = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    private let mainScreenModel: MainScreenModel

    init(mainScreenModel: MainScreenModel) {
        self.mainScreenModel = mainScreenModel
        setupRxBindings()
    }

    private func setupRxBindings() {
        requestCounter
            .bind(to: mainScreenModel.requestCounter)
            .disposed(by: disposeBag)

        shakeAction
            .bind(to: mainScreenModel.shakeAction)
            .disposed(by: disposeBag)

        mainScreenModel.loadingState
            .bind(to: loadingState)
            .disposed(by: disposeBag)

        mainScreenModel.didUpdateAnswer
            .map { PresentableAnswer($0) }
            .bind(to: didUpdateAnswer)
            .disposed(by: disposeBag)

        mainScreenModel.didUpdateCounter
            .map { L10n.counter + String($0) }
            .bind(to: didUpdateCounter)
            .disposed(by: disposeBag)

        mainScreenModel.didReceiveAnError
            .bind(to: didReceiveAnError)
            .disposed(by: disposeBag)

    }
}

// Приводим ответ к модели Presentable Answer и редактируем текст
extension PresentableAnswer {

    init(_ answer: Answer) {
        self.text = answer.magic.answer.uppercased()
    }

}
