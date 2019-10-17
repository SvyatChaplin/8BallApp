//
//  StorageManager.swift
//  8Ball
//
//  Created by Svyat Chaplin on 13.10.2019.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import RealmSwift

enum CollectionChange<T> {

    case initial(T)
    case update(T, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int])
    case error(Error)

}

class StorageManagerService: StorageManager {

    private var listObservingToken: NotificationToken?

    private var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print(L10n.realmError, error)
        }
        return self.realm
    }

    private let backgroundQueue = DispatchQueue(label: L10n.queueLabel, qos: .background, attributes: .concurrent)

    // Безопасная запись в БД
    private func write(realm: Realm, writeClosure: () -> Void) {
        do {
            try realm.write {
                writeClosure()
            }
        } catch {
            print(L10n.realmError, error)
        }
    }

    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void) {
        let list = realm.objects(StoredAnswer.self)
        listObservingToken = list.observe { changes in
            switch changes {
            case .initial(let list):
                callback(.initial(list.map(Answer.init)))
            case .update(let list, let deletions, let insertions, let modifications):
                callback(.update(list.map(Answer.init), deletions, insertions, modifications))
            case .error(let error):
                callback(.error(error))
            }
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
            autoreleasepool {
                let storedAnswer = StoredAnswer(answer: answer)
                self.write(realm: self.realm) {
                    self.realm.add(storedAnswer)
                }
            }
        }
    }

    // Получаем массив данных из БД
    func getObjects() -> [Answer] {
        var answers = realm.objects(StoredAnswer.self)
        answers = answers.sorted(byKeyPath: L10n.KeyPath.date, ascending: false)
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
            autoreleasepool {
                self.write(realm: self.realm) {
                    self.realm.deleteAll()
                }
            }
        }
    }

    deinit {
        listObservingToken?.invalidate()
    }

}

extension Answer {

    init(answer: StoredAnswer) {
        magic = Magic(answer: answer.answer ?? L10n.ConnectionError.title, date: answer.date)
    }

}
