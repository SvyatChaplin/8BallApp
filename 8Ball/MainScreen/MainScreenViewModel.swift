//
//  MainScreenViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/28/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import UIKit

class MainScreenViewModel {

    var attemptToRequestAnAnswer: (() -> Void)?
    var didUpdateActivityState: ((Bool) -> Void)?
    var didUpdateAnswer: ((String?) -> Void)? {
        get { mainScreenModel.didUpdateAnswer }
        set { mainScreenModel.didUpdateAnswer = newValue }
    }

    private let mainScreenModel: MainScreenModel

    init(mainScreenModel: MainScreenModel) {
        self.mainScreenModel = mainScreenModel
        setupBindings()
    }

    private func setupBindings() {
        attemptToRequestAnAnswer = { [weak self] in
            self?.didUpdateActivityState?(true)
            self?.mainScreenModel.requestAnswer { [weak self] in
                self?.didUpdateActivityState?(false)
            }
        }
    }
}
