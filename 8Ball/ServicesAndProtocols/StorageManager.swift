//
//  StorageManager.swift
//  8Ball
//
//  Created by Svyat Chaplin on 14.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RealmSwift

protocol StorageManager {

    func saveObject(_ answer: Answer)
    func getRandomElement() -> (answer: Answer?, error: Error?)
    func deleteAllObjects()
    func deleteLastObject()
    func getObjects() -> [Answer]
    func deleteObject(_ answer: Answer)
    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void)

}
