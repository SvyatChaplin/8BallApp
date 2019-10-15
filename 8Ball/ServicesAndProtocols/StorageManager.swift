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

    static func saveObject(_ answer: Answer)
    func getRandomElement() -> (answer: Answer?, error: Error?)
    static func deleteAllObject()
    static func deleteLastObject()
    func getObjects() -> [Answer]

}
