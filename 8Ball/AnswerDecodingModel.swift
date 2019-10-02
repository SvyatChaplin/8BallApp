//
//  AnswerModel.swift
//  8Ball
//
//  Created by Svyat Chaplin on 9/2/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

// Модель для декодирования JSON - данных 
struct AnswerDecodingModel: Decodable {
    struct Magic: Decodable {
        let question: String
        let answer: String
        let type: String
    }
    let magic: Magic
}
