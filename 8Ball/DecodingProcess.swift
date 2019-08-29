//
//  DecidingProcess.swift
//  8Ball
//
//  Created by Svyat Chaplin on 8/29/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

class DecodingProcess {
    
    func decoding(data: Data?) -> [String: [String: String]]? {
        do {
            let dict = try JSONDecoder().decode([String: [String: String]].self, from: data!)
            return dict
        } catch {
            return nil
        }
    
    
    }
}
