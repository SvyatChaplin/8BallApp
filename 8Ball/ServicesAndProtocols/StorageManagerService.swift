//
//  StorageManager.swift
//  8Ball
//
//  Created by Svyat Chaplin on 13.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManagerService: StorageManager {

    var answerModel: StoredAnswer!
    var answers: Results<StoredAnswer>!

    static var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print("Could not write to database: ", error)
        }
        return self.realm
    }

    public static func write(realm: Realm, writeClosure: () -> Void) {
        do {
            try realm.write {
                writeClosure()
            }
        } catch {
            print("Could not write to database: ", error)
        }
    }

    // Сохранение в хранилище
    static func saveObject(_ answer: Answer) {
        let storedAnswer = StoredAnswer(answer: answer)
        StorageManagerService.write(realm: realm) {
            realm.add(storedAnswer)
        }
    }

    func getObjects() -> [Answer] {
        var answers = StorageManagerService.realm.objects(StoredAnswer.self)
        answers = answers.sorted(byKeyPath: "date", ascending: false)
        let array = Array(answers)
        var answerArray: [Answer] = []
        for item in array {
            let answer = Answer(answer: item)
            answerArray.append(answer)
        }
        return answerArray
    }

    func getRandomElement() -> (answer: Answer?, error: Error?) {
        let answer = StorageManagerService.realm.objects(StoredAnswer.self)
        if let randomAnswer = answer.randomElement() {
            return (Answer(answer: randomAnswer), nil)
        } else {
            let error = L10n.EmptyArrayWarning.message as? Error
            return (nil, error)
        }
    }

    // Удаление обЪектов из хранилища
    static func deleteAllObject() {
        StorageManagerService.write(realm: realm) {
            realm.deleteAll()
        }
    }

    static func deleteLastObject() {
    }
}

extension Answer {

    init(answer: StoredAnswer) {
        magic = Magic(answer: answer.answer!)
    }

}
