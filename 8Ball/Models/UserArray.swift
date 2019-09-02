//
//  UserArray.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/27/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

// Глобальная переменная, в которую пользователь может добавлять свои варианты ответов. Также они сохраняются на устройстве и при повторном запуске наши настройки не пропадут

var userArray: [String] {
    get {
        return UserDefaults.standard.array(forKey: "userArray") as? [String] ?? ["Yes", "No", "Just do it", "Why not?"]
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "userArray")
    }
}


