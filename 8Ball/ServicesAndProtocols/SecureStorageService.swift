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

    private var countOfShakes: Int {
        get {
            return KeychainWrapper.standard.integer(forKey: L10n.keyChainKey) ?? 0
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: L10n.keyChainKey)
        }
    }

    // Get counter data
    func getCountInt() -> Int {
        return countOfShakes
    }

    // Updating counter data
    func updateCounts(_ count: Int) {
        countOfShakes = count
    }

}
