//
//  SecureStorage.swift
//  8Ball
//
//  Created by Svyat Chaplin on 10/9/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class SecureStorageService: SecureStorage {

    // Храним показания счетчика
    private var countOfShakes: Int {
        get {
            return KeychainWrapper.standard.integer(forKey: L10n.keyChainKey) ?? 0
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: L10n.keyChainKey)
        }
    }

    // Отдаем показания счетчика
    func getCountInt() -> Int {
        return countOfShakes
    }

    // Обновляем показания счетчика
    func updateCounts(_ count: Int) {
        countOfShakes = count
    }

}
