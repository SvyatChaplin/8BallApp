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

    // Конвертируем показания счетчика в строку
    func getCount() -> String {
        return L10n.counter + String(countOfShakes)
    }

    // Обновляем показания счетчика
    func updateCount() {
        var count = KeychainWrapper.standard.integer(forKey: L10n.keyChainKey) ?? 0
        count += 1
        countOfShakes = count
    }

}
