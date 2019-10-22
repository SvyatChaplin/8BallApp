//
//  HistoryModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class HistoryModel {

    private var storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func getObjects() -> [Answer] {
        return storageManager.getObjects()
    }

    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void) {
        storageManager.observeAnswerList(callback)
    }

    func deleteObject(_ answer: Answer) {
        storageManager.deleteObject(answer)
    }

    func removeAllAnswers() {
        storageManager.deleteAllObjects()
    }

    func appendAnswer(_ answer: Answer) {
        storageManager.saveObject(answer)
    }

}
