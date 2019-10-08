//
//  NetworkingManager.swift
//  8Ball
//
//  Created by Svyat Chaplin on 10/2/19.
//  Copyright © 2019 Svyat Chaplin. All rights reserved.
//

import Foundation

protocol NetworkingManager {

    func checkConnection() -> Bool
    func decodingData(data: Data?, error: Error?) -> (answer: Answer?, error: Error?)
    func fetchData(complitionHandler: @escaping (Data?, Error?) -> Void)

}
