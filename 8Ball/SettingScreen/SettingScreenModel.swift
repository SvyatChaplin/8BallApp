//
//  SettingScreenModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/29/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class SettingScreenModel {

    private var storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    // Добавляем новый ответ в хранилище
    func appendAnswer(_ answer: Answer) {
        storageManager.saveObject(answer)
    }

    // Удаляем все содержимое хранилища
    func removeAllAnswers() {
        storageManager.deleteAllObjects()
    }

    func getObjects() -> [Answer] {
        return storageManager.getObjects()
    }

}
