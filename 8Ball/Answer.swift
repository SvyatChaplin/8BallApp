//
//  AnswerModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/2/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

// Модель для декодирования JSON - данных
struct Answer: Decodable {

    var magic: Magic

}

struct Magic: Decodable {

    var answer: String

}
