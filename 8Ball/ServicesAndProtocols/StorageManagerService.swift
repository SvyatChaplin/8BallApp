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

    func observeAnswerList(_ callback: @escaping (CollectionChange<[Answer]>) -> Void) {
        var list = realm.objects(StoredAnswer.self)
        list = list.sorted(byKeyPath: #keyPath(StoredAnswer.date), ascending: false)
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
    func deleteObject(at index: Int) {
        backgroundQueue.async {
            autoreleasepool {
                let realm = self.realm
                let storedAnswers = realm.objects(StoredAnswer.self)
                let answer = self.getObjects()[index]
                for storedAnswer in storedAnswers where storedAnswer.date == answer.magic.date {
                    self.write(realm: realm) {
                        realm.delete(storedAnswer)
                    }
                }
            }
        }
    }

    // Сохранение в БД
    func saveObject(_ answer: Answer) {
        backgroundQueue.async {
            autoreleasepool {
                let realm = self.realm
                let storedAnswer = StoredAnswer(answer: answer)
                self.write(realm: realm) {
                    realm.add(storedAnswer)
                }
            }
        }
    }

    // Получаем массив данных из БД
    func getObjects() -> [Answer] {
        var answers = realm.objects(StoredAnswer.self)
        answers = answers.sorted(byKeyPath: #keyPath(StoredAnswer.date), ascending: false)
        let array = Array(answers)
        return array.map(Answer.init)
    }

    // Получаем рандомный ответ из БД
    func getRandomElement() -> Answer? {
        let answer = realm.objects(StoredAnswer.self)
        if let randomAnswer = answer.randomElement() {
            return Answer(answer: randomAnswer)
        } else {
            return nil
        }
    }

    // Удаление обЪектов из БД
    func deleteAllObjects() {
        backgroundQueue.async {
            autoreleasepool {
                let realm = self.realm
                self.write(realm: realm) {
                    realm.deleteAll()
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
