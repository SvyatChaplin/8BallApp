//
//  AnswerReadyToUse.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/29/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation


class AnswersReadyToUse {
    
    let networkingProcess = NetworkingProcess()
    let decodingProcess = DecodingProcess()
    
    func readyAnswer (completionHandler: @escaping (String) -> Void) {
        networkingProcess.getAnswerFromInternet { (data) in
            let answerFromInternet = self.decodingProcess.decoding(data: data)
            let answerReadyToUse = answerFromInternet!["magic"]!["answer"]!
            completionHandler(answerReadyToUse)
        }
        
    }
    
}
