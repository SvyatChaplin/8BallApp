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

    private var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print("Could not write to database: ", error)
        }
        return self.realm
    }

    private let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .background, attributes: .concurrent)

    // Безопасная запись в БД
    private func write(realm: Realm, writeClosure: () -> Void) {
        do {
            try realm.write {
                writeClosure()
            }
        } catch {
            print("Could not write to database: ", error)
        }
    }

    // Удаляем конкретный объект
    func deleteObject(_ answer: Answer) {
        backgroundQueue.async {
            autoreleasepool {
                let storedAnswers = self.realm.objects(StoredAnswer.self)
                for storedAnswer in storedAnswers where storedAnswer.date == answer.magic.date {
                    self.write(realm: self.realm) {
                        self.realm.delete(storedAnswer)
                    }
                }
            }
        }
    }

    // Сохранение в БД
    func saveObject(_ answer: Answer) {
        backgroundQueue.async {
            let storedAnswer = StoredAnswer(answer: answer)
            self.write(realm: self.realm) {
                self.realm.add(storedAnswer)
            }
        }
    }

    // Получаем массив данных из БД
    func getObjects() -> [Answer] {
        var answers = realm.objects(StoredAnswer.self)
        answers = answers.sorted(byKeyPath: "date", ascending: false)
        let array = Array(answers)
        return array.map(Answer.init)
    }

    // Получаем рандомный ответ из БД
    func getRandomElement() -> (answer: Answer?, error: Error?) {
        let answer = realm.objects(StoredAnswer.self)
        if let randomAnswer = answer.randomElement() {
            return (Answer(answer: randomAnswer), nil)
        } else {
            let error = L10n.EmptyArrayWarning.message as? Error
            return (nil, error)
        }
    }

    // Удаление обЪектов из БД
    func deleteAllObjects() {
        backgroundQueue.async {
            self.write(realm: self.realm) {
                self.realm.deleteAll()
            }
        }
    }

    // Удаляем последний добавленный элемент из БД
    func deleteLastObject() {
        backgroundQueue.async {
            let answers = self.realm.objects(StoredAnswer.self)
            if let lastAnswer = answers.last {
                self.write(realm: self.realm) {
                    self.realm.delete(lastAnswer)
                }
            } else {
                self.write(realm: self.realm) {
                    self.realm.deleteAll()
                }
            }
        }
    }

}

extension Answer {

    init(answer: StoredAnswer) {
        magic = Magic(answer: answer.answer!, date: answer.date)
    }

}
