//
//  SettingScreenViewModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/28/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class SettingScreenViewModel {

    private let settingScreenModel: SettingScreenModel

    init(settingScreenModel: SettingScreenModel) {
        self.settingScreenModel = settingScreenModel
    }

    var newAnswer: String?

}
